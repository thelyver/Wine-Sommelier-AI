import { useState, useRef, useEffect, useMemo } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { X, Send, Wine, Sparkles, Loader2, User } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import { ScrollArea } from "@/components/ui/scroll-area";
import { apiRequest } from "@/lib/queryClient";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import rehypeRaw from "rehype-raw";
import type { Wine as WineType, Message, Conversation } from "@shared/schema";

interface SommelierChatProps {
  onClose: () => void;
  onSelectWine: (wine: WineType) => void;
}

// Preprocess markdown to fix bold markers that don't render properly
function preprocessMarkdown(content: string): string {
  // Replace **text** patterns that might not render with <strong> tags
  // This handles cases where special characters inside bold markers cause issues
  return content.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
}

export function SommelierChat({ onClose, onSelectWine }: SommelierChatProps) {
  const [input, setInput] = useState("");
  const [isStreaming, setIsStreaming] = useState(false);
  const [streamedContent, setStreamedContent] = useState("");
  const [pendingUserMessage, setPendingUserMessage] = useState<string | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const userMessageRef = useRef<HTMLDivElement>(null);
  const queryClient = useQueryClient();

  // Get or create conversation
  const { data: conversation } = useQuery<Conversation>({
    queryKey: ["/api/sommelier/conversation"],
  });

  // Get messages
  const { data: messages = [] } = useQuery<Message[]>({
    queryKey: ["/api/sommelier/messages", conversation?.id],
    enabled: !!conversation?.id,
  });

  // Get all wines for linking (no filters to get complete wine list)
  const { data: allWines = [] } = useQuery<WineType[]>({
    queryKey: ["/api/wines/all"],
    queryFn: async () => {
      const res = await fetch("/api/wines?limit=500");
      if (!res.ok) throw new Error("Failed to fetch wines");
      return res.json();
    },
  });

  // Create wine lookup map
  const wineMap = useMemo(() => {
    const map = new Map<string, WineType>();
    allWines.forEach((wine) => map.set(wine.id, wine));
    return map;
  }, [allWines]);

  // Handle wine link clicks
  const handleWineClick = (wineId: string) => {
    console.log("Wine link clicked:", wineId, "Map size:", wineMap.size);
    const wine = wineMap.get(wineId);
    console.log("Found wine:", wine?.nameKr);
    if (wine) {
      onSelectWine(wine);
    } else {
      console.warn("Wine not found in map for ID:", wineId);
    }
  };

  const sendMessage = useMutation({
    mutationFn: async (content: string) => {
      if (!conversation?.id) {
        throw new Error("No conversation");
      }

      setPendingUserMessage(content);
      setInput("");
      setIsStreaming(true);
      setStreamedContent("");

      const response = await fetch(`/api/sommelier/chat`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          conversationId: conversation.id,
          content,
        }),
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
              // Ignore parse errors for malformed JSON
            }
          }
        }
      } finally {
        // Ensure streaming state is always reset
        setIsStreaming(false);
      }

      return fullContent;
    },
    onSuccess: () => {
      setIsStreaming(false);
      setStreamedContent("");
      setPendingUserMessage(null);
      queryClient.invalidateQueries({ queryKey: ["/api/sommelier/messages"] });
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

  // Scroll to user message when it's sent
  useEffect(() => {
    if (pendingUserMessage && userMessageRef.current) {
      userMessageRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }, [pendingUserMessage]);

  // Scroll to bottom as streaming content grows or when new messages are added
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

  return (
    <div className="flex h-full flex-col">
      {/* Header */}
      <div className="flex items-center justify-between border-b border-border bg-sidebar p-4">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-full bg-accent">
            <Sparkles className="h-5 w-5 text-accent-foreground" />
          </div>
          <div>
            <h3 className="font-semibold text-sidebar-foreground">AI 소믈리에</h3>
            <p className="text-xs text-sidebar-foreground/70">와인 추천 전문가</p>
          </div>
        </div>
        <Button
          variant="ghost"
          size="icon"
          onClick={onClose}
          className="text-sidebar-foreground"
          data-testid="button-close-chat"
        >
          <X className="h-5 w-5" />
        </Button>
      </div>

      {/* Messages */}
      <ScrollArea className="flex-1 p-4">
        <div className="space-y-4">
          {/* Welcome Message */}
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

              {/* Suggestion Chips */}
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

          {/* Chat Messages */}
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
                      {preprocessMarkdown(msg.content)}
                    </ReactMarkdown>
                  </div>
                )}
              </div>
            </div>
          ))}

          {/* Pending User Message (shown immediately when user sends) */}
          {pendingUserMessage && (
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

          {/* Streaming Response */}
          {isStreaming && (
            <div className="flex gap-3">
              <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-accent">
                <Wine className="h-4 w-4 text-accent-foreground" />
              </div>
              <div className="max-w-[80%] rounded-lg bg-muted p-3">
                {streamedContent ? (
                  <div className="text-sm leading-relaxed [&_h2]:text-base [&_h2]:font-semibold [&_h2]:mt-4 [&_h2]:mb-2 [&_p]:my-2 [&_ul]:my-2 [&_ul]:pl-4 [&_li]:my-1 [&_strong]:font-semibold">
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
                      {preprocessMarkdown(streamedContent)}
                    </ReactMarkdown>
                  </div>
                ) : (
                  <span className="flex items-center gap-2 text-muted-foreground text-sm">
                    <Loader2 className="h-4 w-4 animate-spin" />
                    생각중...
                  </span>
                )}
              </div>
            </div>
          )}
          <div ref={scrollRef} />
        </div>
      </ScrollArea>

      {/* Input */}
      <form onSubmit={handleSubmit} className="border-t border-border p-4">
        <div className="flex gap-2">
          <Textarea
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="와인에 대해 물어보세요..."
            className="min-h-[44px] max-h-32 resize-none"
            onKeyDown={(e) => {
              if (e.key === "Enter" && !e.shiftKey) {
                e.preventDefault();
                handleSubmit(e);
              }
            }}
            disabled={isStreaming}
            data-testid="input-chat"
          />
          <Button
            type="submit"
            size="icon"
            disabled={!input.trim() || isStreaming}
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
    </div>
  );
}
