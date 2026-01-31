import { useState, useRef, useEffect, useMemo } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { X, Send, Wine, Sparkles, Loader2, User, Plus, Search, MessageSquare, Trash2, History, AlertCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Badge } from "@/components/ui/badge";
import { apiRequest } from "@/lib/queryClient";
import { useAuth } from "@/contexts/auth-context";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeRaw from "rehype-raw";
import type { Wine as WineType, Message, Conversation } from "@shared/schema";

interface SommelierChatProps {
  onClose: () => void;
  onSelectWine: (wine: WineType) => void;
}

interface LocalMessage {
  id: number;
  role: "user" | "assistant";
  content: string;
  createdAt: Date;
}

function preprocessMarkdown(content: string): string {
  return content.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
}

export function SommelierChat({ onClose, onSelectWine }: SommelierChatProps) {
  const { isAuthenticated } = useAuth();
  const [input, setInput] = useState("");
  const [isStreaming, setIsStreaming] = useState(false);
  const [streamedContent, setStreamedContent] = useState("");
  const [pendingUserMessage, setPendingUserMessage] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<"chat" | "history">("chat");
  const [searchQuery, setSearchQuery] = useState("");
  const [activeConversationId, setActiveConversationId] = useState<number | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const userMessageRef = useRef<HTMLDivElement>(null);
  const queryClient = useQueryClient();

  const [localMessages, setLocalMessages] = useState<LocalMessage[]>([]);
  const [localMessageId, setLocalMessageId] = useState(1);

  const { data: allConversations = [] } = useQuery<Conversation[]>({
    queryKey: ["/api/sommelier/conversations"],
    enabled: isAuthenticated,
  });

  const { data: defaultConversation } = useQuery<Conversation>({
    queryKey: ["/api/sommelier/conversation"],
    enabled: isAuthenticated && !activeConversationId,
  });

  useEffect(() => {
    if (isAuthenticated && defaultConversation && !activeConversationId) {
      setActiveConversationId(defaultConversation.id);
    }
  }, [defaultConversation, activeConversationId, isAuthenticated]);

  const conversation = isAuthenticated 
    ? (allConversations.find(c => c.id === activeConversationId) || defaultConversation)
    : null;

  const { data: dbMessages = [] } = useQuery<Message[]>({
    queryKey: ["/api/sommelier/messages", activeConversationId],
    enabled: isAuthenticated && !!activeConversationId,
  });

  const messages = isAuthenticated ? dbMessages : localMessages;

  const { data: searchResults = [] } = useQuery<{ conversation: Conversation; matchedMessages: Message[] }[]>({
    queryKey: ["/api/sommelier/search", searchQuery],
    queryFn: async () => {
      if (!searchQuery.trim()) return [];
      const res = await fetch(`/api/sommelier/search?q=${encodeURIComponent(searchQuery)}`);
      if (!res.ok) throw new Error("Search failed");
      return res.json();
    },
    enabled: isAuthenticated && !!searchQuery.trim(),
  });

  const createConversation = useMutation({
    mutationFn: async () => {
      const res = await apiRequest("POST", "/api/sommelier/conversations", { title: "새 대화" });
      return res.json();
    },
    onSuccess: (newConv: Conversation) => {
      setActiveConversationId(newConv.id);
      queryClient.invalidateQueries({ queryKey: ["/api/sommelier/conversations"] });
    },
  });

  const deleteConversation = useMutation({
    mutationFn: async (id: number) => {
      await apiRequest("DELETE", `/api/sommelier/conversations/${id}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["/api/sommelier/conversations"] });
      if (allConversations.length > 1) {
        const remaining = allConversations.filter(c => c.id !== activeConversationId);
        if (remaining.length > 0) {
          setActiveConversationId(remaining[0].id);
        }
      } else {
        createConversation.mutate();
      }
    },
  });

  const { data: allWines = [] } = useQuery<WineType[]>({
    queryKey: ["/api/wines/all"],
    queryFn: async () => {
      const res = await fetch("/api/wines?limit=500");
      if (!res.ok) throw new Error("Failed to fetch wines");
      return res.json();
    },
  });

  const wineMap = useMemo(() => {
    const map = new Map<string, WineType>();
    allWines.forEach((wine) => map.set(wine.id, wine));
    return map;
  }, [allWines]);

  const handleWineClick = (wineId: string) => {
    const wine = wineMap.get(wineId);
    if (wine) {
      onSelectWine(wine);
    }
  };

  const sendMessage = useMutation({
    mutationFn: async (content: string) => {
      if (isAuthenticated && !conversation?.id) {
        throw new Error("대화를 시작할 수 없습니다. 잠시 후 다시 시도해주세요.");
      }

      setPendingUserMessage(content);
      setInput("");
      setIsStreaming(true);
      setStreamedContent("");

      if (!isAuthenticated) {
        const userMsg: LocalMessage = {
          id: localMessageId,
          role: "user",
          content,
          createdAt: new Date(),
        };
        setLocalMessages(prev => [...prev, userMsg]);
        setLocalMessageId(prev => prev + 1);
      }

      const endpoint = isAuthenticated 
        ? `/api/sommelier/chat`
        : `/api/sommelier/chat/guest`;

      const body = isAuthenticated
        ? { conversationId: conversation!.id, content }
        : { content, history: localMessages.slice(-10).map(m => ({ role: m.role, content: m.content })) };

      const response = await fetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });

      if (!response.ok) throw new Error("Failed to send message");

      const reader = response.body?.getReader();
      if (!reader) throw new Error("No response body");

      const decoder = new TextDecoder();
      let buffer = "";
      let fullContent = "";

      try {
        while (true) {
          const { done, value } = await reader.read();
          if (done) break;

          buffer += decoder.decode(value, { stream: true });
          const lines = buffer.split("\n");
          buffer = lines.pop() || "";

          for (const line of lines) {
            if (!line.startsWith("data: ")) continue;
            try {
              const data = JSON.parse(line.slice(6));
              if (data.content) {
                fullContent += data.content;
                setStreamedContent(fullContent);
              }
              if (data.done) {
                setIsStreaming(false);
              }
              if (data.error) {
                throw new Error(data.error);
              }
            } catch (e) {
            }
          }
        }
      } finally {
        setIsStreaming(false);
      }

      return fullContent;
    },
    onSuccess: (fullContent) => {
      setIsStreaming(false);
      setStreamedContent("");
      setPendingUserMessage(null);

      if (!isAuthenticated && fullContent) {
        const assistantMsg: LocalMessage = {
          id: localMessageId,
          role: "assistant",
          content: fullContent,
          createdAt: new Date(),
        };
        setLocalMessages(prev => [...prev, assistantMsg]);
        setLocalMessageId(prev => prev + 1);
      }

      if (isAuthenticated) {
        queryClient.invalidateQueries({ queryKey: ["/api/sommelier/messages"] });
      }
    },
    onError: (error) => {
      console.error("Chat error:", error);
      setIsStreaming(false);
      setStreamedContent("");
      setPendingUserMessage(null);
    },
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!input.trim() || isStreaming) return;
    sendMessage.mutate(input.trim());
  };

  const handleNewLocalChat = () => {
    setLocalMessages([]);
    setLocalMessageId(1);
  };

  useEffect(() => {
    if (pendingUserMessage && userMessageRef.current) {
      userMessageRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }, [pendingUserMessage]);

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollIntoView({ behavior: "smooth", block: "end" });
    }
  }, [streamedContent, messages]);

  const suggestionQuestions = [
    "오늘 혼술하려는데 레드 와인 추천해줘",
    "데이트할 때 마실 와인 추천해줘",
    "스테이크랑 어울리는 와인 알려줘",
    "5만원대 선물용 와인 뭐가 좋을까?",
  ];

  const formatDate = (date: Date) => {
    const d = new Date(date);
    return d.toLocaleDateString("ko-KR", { month: "short", day: "numeric" });
  };

  const renderMarkdownContent = (content: string) => (
    <ReactMarkdown
      remarkPlugins={[remarkGfm]}
      rehypePlugins={[rehypeRaw]}
      components={{
        a: ({ href, children }) => {
          if (href && href.startsWith("#wine-")) {
            const wineId = href.replace("#wine-", "");
            return (
              <span
                role="button"
                tabIndex={0}
                onClick={(e) => {
                  e.preventDefault();
                  e.stopPropagation();
                  handleWineClick(wineId);
                }}
                onKeyDown={(e) => e.key === "Enter" && handleWineClick(wineId)}
                className="text-primary underline decoration-primary/50 hover:decoration-primary font-medium cursor-pointer"
                data-testid={`wine-link-${wineId}`}
              >
                {children}
              </span>
            );
          }
          return <a href={href} className="text-primary underline">{children}</a>;
        },
        strong: ({ children }) => <strong className="font-semibold text-foreground">{children}</strong>,
        h2: ({ children }) => <h2 className="text-base font-semibold mt-4 mb-2">{children}</h2>,
        p: ({ children }) => <p className="my-2">{children}</p>,
        ul: ({ children }) => <ul className="my-2 pl-4 list-disc">{children}</ul>,
        li: ({ children }) => <li className="my-1">{children}</li>,
      }}
    >
      {preprocessMarkdown(content)}
    </ReactMarkdown>
  );

  return (
    <div className="flex h-full flex-col">
      <div className="flex items-center justify-between border-b border-border bg-primary p-4">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary-foreground/20">
            <Sparkles className="h-5 w-5 text-primary-foreground" />
          </div>
          <div>
            <h3 className="font-semibold text-primary-foreground">AI 소믈리에</h3>
            <p className="text-xs text-primary-foreground/70">와인 추천 전문가</p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          {isAuthenticated ? (
            <Button
              size="sm"
              onClick={() => createConversation.mutate()}
              className="gap-1 bg-white text-primary hover:bg-white/90"
              data-testid="button-new-chat-header"
            >
              <Plus className="h-4 w-4" />
              새 대화
            </Button>
          ) : (
            <Button
              size="sm"
              onClick={handleNewLocalChat}
              className="gap-1 bg-white text-primary hover:bg-white/90"
              data-testid="button-new-chat-header"
            >
              <Plus className="h-4 w-4" />
              새 대화
            </Button>
          )}
          <Button
            size="icon"
            onClick={onClose}
            className="bg-transparent text-primary-foreground hover:bg-primary-foreground/20"
            data-testid="button-close-chat"
          >
            <X className="h-5 w-5" />
          </Button>
        </div>
      </div>

      {isAuthenticated ? (
        <div className="flex border-b border-border">
          <button
            onClick={() => setActiveTab("chat")}
            className={`flex-1 py-3 text-sm font-medium transition-colors ${
              activeTab === "chat"
                ? "border-b-2 border-primary text-primary"
                : "text-muted-foreground hover:text-foreground"
            }`}
            data-testid="tab-chat"
          >
            <div className="flex items-center justify-center gap-2">
              <MessageSquare className="h-4 w-4" />
              채팅
            </div>
          </button>
          <button
            onClick={() => setActiveTab("history")}
            className={`flex-1 py-3 text-sm font-medium transition-colors ${
              activeTab === "history"
                ? "border-b-2 border-primary text-primary"
                : "text-muted-foreground hover:text-foreground"
            }`}
            data-testid="tab-history"
          >
            <div className="flex items-center justify-center gap-2">
              <History className="h-4 w-4" />
              이전 대화
            </div>
          </button>
        </div>
      ) : (
        <div className="flex items-center gap-2 px-4 py-2 bg-amber-50 dark:bg-amber-950 border-b border-amber-200 dark:border-amber-800">
          <AlertCircle className="h-4 w-4 text-amber-600 dark:text-amber-400 shrink-0" />
          <p className="text-xs text-amber-700 dark:text-amber-300">
            로그인하면 대화 기록이 저장됩니다
          </p>
        </div>
      )}

      {isAuthenticated && activeTab === "history" ? (
        <div className="flex-1 flex flex-col">
          <div className="p-3 border-b border-border">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input
                placeholder="대화 검색..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-9"
                data-testid="input-search-conversations"
              />
            </div>
          </div>

          <ScrollArea className="flex-1">
            <div className="p-3 space-y-2">
              {searchQuery.trim() ? (
                searchResults.length > 0 ? (
                  searchResults.map(({ conversation: conv }) => (
                    <div
                      key={conv.id}
                      onClick={() => {
                        setActiveConversationId(conv.id);
                        setSearchQuery("");
                        setActiveTab("chat");
                      }}
                      className={`p-3 rounded-md cursor-pointer hover-elevate border border-border ${
                        conv.id === activeConversationId ? "bg-accent" : "bg-card"
                      }`}
                    >
                      <div className="flex items-center gap-2">
                        <MessageSquare className="h-4 w-4 text-muted-foreground shrink-0" />
                        <span className="font-medium truncate">{conv.title}</span>
                      </div>
                      <div className="text-xs text-muted-foreground mt-1">
                        {formatDate(conv.createdAt)}
                      </div>
                    </div>
                  ))
                ) : (
                  <p className="text-sm text-muted-foreground text-center py-8">검색 결과가 없습니다</p>
                )
              ) : allConversations.length > 0 ? (
                allConversations.map((conv) => (
                  <div
                    key={conv.id}
                    className={`group p-3 rounded-md cursor-pointer hover-elevate border border-border ${
                      conv.id === activeConversationId ? "bg-accent" : "bg-card"
                    }`}
                  >
                    <div 
                      onClick={() => {
                        setActiveConversationId(conv.id);
                        setActiveTab("chat");
                      }}
                      className="flex items-center gap-2"
                    >
                      <MessageSquare className="h-4 w-4 text-muted-foreground shrink-0" />
                      <span className="font-medium truncate flex-1">{conv.title}</span>
                      <Button
                        variant="ghost"
                        size="icon"
                        className="h-7 w-7 opacity-0 group-hover:opacity-100"
                        onClick={(e) => {
                          e.stopPropagation();
                          deleteConversation.mutate(conv.id);
                        }}
                        data-testid={`button-delete-conversation-${conv.id}`}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                    <div className="text-xs text-muted-foreground mt-1">
                      {formatDate(conv.createdAt)}
                    </div>
                  </div>
                ))
              ) : (
                <div className="text-center py-8">
                  <MessageSquare className="h-12 w-12 text-muted-foreground mx-auto mb-3" />
                  <p className="text-sm text-muted-foreground">아직 대화가 없습니다</p>
                  <Button
                    onClick={() => {
                      createConversation.mutate();
                      setActiveTab("chat");
                    }}
                    className="mt-3"
                    size="sm"
                  >
                    <Plus className="h-4 w-4 mr-2" />
                    새 대화 시작
                  </Button>
                </div>
              )}
            </div>
          </ScrollArea>
        </div>
      ) : (
        <>
        <ScrollArea className="flex-1 p-4">
        <div className="space-y-4">
          {messages.length === 0 && !isStreaming && (
            <div className="space-y-4">
              <div className="flex gap-3">
                <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-accent">
                  <Wine className="h-4 w-4 text-accent-foreground" />
                </div>
                <div className="flex-1 rounded-lg bg-muted p-4">
                  <p className="text-sm">
                    안녕하세요! 저는 AI 와인 소믈리에입니다. 
                    어떤 상황에서 와인을 즐기실 건가요? 
                    음식, 분위기, 취향을 알려주시면 딱 맞는 와인을 추천해드릴게요.
                  </p>
                </div>
              </div>

              <div className="pl-11">
                <p className="mb-2 text-xs text-muted-foreground">이렇게 물어보세요:</p>
                <div className="flex flex-wrap gap-2">
                  {suggestionQuestions.map((q, i) => (
                    <Button
                      key={i}
                      variant="outline"
                      size="sm"
                      className="text-xs"
                      onClick={() => setInput(q)}
                      data-testid={`button-suggestion-${i}`}
                    >
                      {q}
                    </Button>
                  ))}
                </div>
              </div>
            </div>
          )}

          {messages.map((msg) => (
            <div
              key={msg.id}
              className={`flex gap-3 ${msg.role === "user" ? "flex-row-reverse" : ""}`}
            >
              <div
                className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full ${
                  msg.role === "user" ? "bg-primary" : "bg-accent"
                }`}
              >
                {msg.role === "user" ? (
                  <User className="h-4 w-4 text-primary-foreground" />
                ) : (
                  <Wine className="h-4 w-4 text-accent-foreground" />
                )}
              </div>
              <div
                className={`max-w-[80%] rounded-lg p-3 ${
                  msg.role === "user"
                    ? "bg-primary text-primary-foreground"
                    : "bg-muted"
                }`}
                data-testid={`message-${msg.id}`}
              >
                {msg.role === "user" ? (
                  <p className="whitespace-pre-wrap text-sm">{msg.content}</p>
                ) : (
                  <div className="text-sm leading-relaxed [&_h2]:text-base [&_h2]:font-semibold [&_h2]:mt-4 [&_h2]:mb-2 [&_p]:my-2 [&_ul]:my-2 [&_ul]:pl-4 [&_li]:my-1 [&_strong]:font-semibold">
                    {renderMarkdownContent(msg.content)}
                  </div>
                )}
              </div>
            </div>
          ))}

          {pendingUserMessage && !isAuthenticated && (
            <div
              ref={userMessageRef}
              className="flex gap-3 flex-row-reverse"
            >
              <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-primary">
                <User className="h-4 w-4 text-primary-foreground" />
              </div>
              <div className="max-w-[80%] rounded-lg p-3 bg-primary text-primary-foreground">
                <p className="whitespace-pre-wrap text-sm">{pendingUserMessage}</p>
              </div>
            </div>
          )}

          {pendingUserMessage && isAuthenticated && (
            <div
              ref={userMessageRef}
              className="flex gap-3 flex-row-reverse"
            >
              <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-primary">
                <User className="h-4 w-4 text-primary-foreground" />
              </div>
              <div className="max-w-[80%] rounded-lg p-3 bg-primary text-primary-foreground">
                <p className="whitespace-pre-wrap text-sm">{pendingUserMessage}</p>
              </div>
            </div>
          )}

          {isStreaming && (
            <div className="flex gap-3">
              <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-accent">
                <Wine className="h-4 w-4 text-accent-foreground" />
              </div>
              <div className="max-w-[80%] rounded-lg bg-muted p-3">
                {streamedContent ? (
                  <div className="text-sm leading-relaxed [&_h2]:text-base [&_h2]:font-semibold [&_h2]:mt-4 [&_h2]:mb-2 [&_p]:my-2 [&_ul]:my-2 [&_ul]:pl-4 [&_li]:my-1 [&_strong]:font-semibold">
                    {renderMarkdownContent(streamedContent)}
                  </div>
                ) : (
                  <div className="flex items-center gap-2 text-sm text-muted-foreground">
                    <Loader2 className="h-4 w-4 animate-spin" />
                    답변을 생성하고 있습니다...
                  </div>
                )}
              </div>
            </div>
          )}

          <div ref={scrollRef} />
        </div>
        </ScrollArea>

        <form onSubmit={handleSubmit} className="border-t border-border p-4">
          <div className="flex gap-2">
            <Textarea
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter" && !e.shiftKey) {
                  e.preventDefault();
                  handleSubmit(e);
                }
              }}
              placeholder="와인에 대해 물어보세요..."
              className="min-h-[44px] max-h-32 resize-none"
              disabled={isStreaming}
              data-testid="input-chat-message"
            />
            <Button
              type="submit"
              size="icon"
              disabled={!input.trim() || isStreaming}
              className="shrink-0"
              data-testid="button-send-message"
            >
              {isStreaming ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <Send className="h-4 w-4" />
              )}
            </Button>
          </div>
        </form>
        </>
      )}
    </div>
  );
}
