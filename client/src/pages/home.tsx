import { useState, useRef, useCallback } from "react";
import { useQuery } from "@tanstack/react-query";
import { useLocation } from "wouter";
import { Wine, MessageSquare, Search, X, Sparkles, ChevronRight, GripVertical, User, LogOut, Shield } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuSeparator, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { WineCard } from "@/components/wine-card";
import { WineFilters } from "@/components/wine-filters";
import { SommelierChat } from "@/components/sommelier-chat";
import { WineDetailModal } from "@/components/wine-detail-modal";
import { ThemeToggle } from "@/components/theme-toggle";
import { AuthModal } from "@/components/auth-modal";
import { useAuth } from "@/contexts/auth-context";
import type { Wine as WineType } from "@shared/schema";

const categoryPills = [
  { id: "RED", label: "레드 와인", color: "bg-rose-600 text-white" },
  { id: "WHITE", label: "화이트 와인", color: "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-100" },
  { id: "SPARKLING", label: "스파클링", color: "bg-cyan-100 text-cyan-800 dark:bg-cyan-900 dark:text-cyan-100" },
  { id: "Rose", label: "로제", color: "bg-pink-200 text-pink-800 dark:bg-pink-900 dark:text-pink-100" },
  { id: "Fortified", label: "주정강화", color: "bg-purple-600 text-white" },
];

export default function Home() {
  const [showChat, setShowChat] = useState(false);
  const [showAuthModal, setShowAuthModal] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedWine, setSelectedWine] = useState<WineType | null>(null);
  const [chatWidth, setChatWidth] = useState(480);
  const [isResizing, setIsResizing] = useState(false);
  const resizeRef = useRef<HTMLDivElement>(null);
  const [, setLocation] = useLocation();
  const { user, isAuthenticated, isAdmin, logout } = useAuth();
  const [filters, setFilters] = useState<{
    type?: string;
    nation?: string;
    occasion?: string;
    priceMin?: number;
    priceMax?: number;
  }>({});

  const handleMouseDown = useCallback((e: React.MouseEvent) => {
    e.preventDefault();
    setIsResizing(true);
    
    const startX = e.clientX;
    const startWidth = chatWidth;
    
    const handleMouseMove = (e: MouseEvent) => {
      const delta = startX - e.clientX;
      const newWidth = Math.min(Math.max(startWidth + delta, 320), 800);
      setChatWidth(newWidth);
    };
    
    const handleMouseUp = () => {
      setIsResizing(false);
      document.removeEventListener("mousemove", handleMouseMove);
      document.removeEventListener("mouseup", handleMouseUp);
    };
    
    document.addEventListener("mousemove", handleMouseMove);
    document.addEventListener("mouseup", handleMouseUp);
  }, [chatWidth]);

  const handleTouchStart = useCallback((e: React.TouchEvent) => {
    e.preventDefault();
    setIsResizing(true);
    
    const startX = e.touches[0].clientX;
    const startWidth = chatWidth;
    
    const handleTouchMove = (e: TouchEvent) => {
      const delta = startX - e.touches[0].clientX;
      const newWidth = Math.min(Math.max(startWidth + delta, 320), 800);
      setChatWidth(newWidth);
    };
    
    const handleTouchEnd = () => {
      setIsResizing(false);
      document.removeEventListener("touchmove", handleTouchMove);
      document.removeEventListener("touchend", handleTouchEnd);
    };
    
    document.addEventListener("touchmove", handleTouchMove, { passive: false });
    document.addEventListener("touchend", handleTouchEnd);
  }, [chatWidth]);

  const { data: wines = [], isLoading } = useQuery<WineType[]>({
    queryKey: ["/api/wines", filters, searchQuery],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (filters.type) params.append("type", filters.type);
      if (filters.nation) params.append("nation", filters.nation);
      if (filters.occasion) params.append("occasion", filters.occasion);
      if (filters.priceMin) params.append("priceMin", filters.priceMin.toString());
      if (filters.priceMax) params.append("priceMax", filters.priceMax.toString());
      if (searchQuery) params.append("search", searchQuery);
      const res = await fetch(`/api/wines?${params.toString()}`);
      if (!res.ok) throw new Error("Failed to fetch wines");
      return res.json();
    },
  });

  const { data: featuredWines = [] } = useQuery<WineType[]>({
    queryKey: ["/api/wines/featured"],
    queryFn: async () => {
      const res = await fetch(`/api/wines/featured?limit=10`);
      if (!res.ok) throw new Error("Failed to fetch featured wines");
      return res.json();
    },
  });

  const activeFilterCount = Object.values(filters).filter(Boolean).length;

  const clearFilters = () => {
    setFilters({});
    setSearchQuery("");
  };

  const handleCategoryClick = (typeId: string) => {
    if (filters.type === typeId) {
      setFilters((prev) => ({ ...prev, type: undefined }));
    } else {
      setFilters((prev) => ({ ...prev, type: typeId }));
    }
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header - Vivino Style */}
      <header className="sticky top-0 z-50 border-b border-border bg-background">
        <div className="container mx-auto px-4">
          <div className="flex h-16 items-center justify-between gap-4">
            <div className="flex items-center gap-3">
              <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary">
                <Wine className="h-5 w-5 text-primary-foreground" />
              </div>
              <span className="text-xl font-bold text-foreground">와인소믈리에</span>
            </div>

            {/* Search Bar - Center */}
            <div className="hidden flex-1 max-w-lg md:flex">
              <div className="relative w-full">
                <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <Input
                  placeholder="와인 이름, 품종, 국가로 검색..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full pl-10 bg-muted/50 border-0"
                  data-testid="input-search"
                />
              </div>
            </div>
            
            <div className="flex items-center gap-2">
              <ThemeToggle />
              <Button
                onClick={() => setShowChat(!showChat)}
                variant={showChat ? "default" : "outline"}
                size="sm"
                className="gap-2"
                data-testid="button-toggle-chat"
              >
                <Sparkles className="h-4 w-4" />
                <span className="hidden sm:inline">AI 소믈리에</span>
              </Button>

              {isAuthenticated ? (
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <Button variant="ghost" size="icon" data-testid="button-user-menu">
                      <User className="h-4 w-4" />
                    </Button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end">
                    <div className="px-2 py-1.5 text-sm">
                      <p className="font-medium">{user?.name || user?.email}</p>
                      {user?.role === "admin" && (
                        <Badge variant="secondary" className="mt-1 text-xs">관리자</Badge>
                      )}
                    </div>
                    <DropdownMenuSeparator />
                    {isAdmin && (
                      <>
                        <DropdownMenuItem onClick={() => setLocation("/admin")} data-testid="menu-admin">
                          <Shield className="mr-2 h-4 w-4" />
                          관리자 페이지
                        </DropdownMenuItem>
                        <DropdownMenuSeparator />
                      </>
                    )}
                    <DropdownMenuItem onClick={() => logout()} data-testid="menu-logout">
                      <LogOut className="mr-2 h-4 w-4" />
                      로그아웃
                    </DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              ) : (
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setShowAuthModal(true)}
                  className="gap-2"
                  data-testid="button-login"
                >
                  <User className="h-4 w-4" />
                  <span className="hidden sm:inline">로그인</span>
                </Button>
              )}
            </div>
          </div>
        </div>
      </header>

      <div className={`flex h-[calc(100vh-4rem)] ${isResizing ? "select-none" : ""}`}>
        {/* Main Content */}
        <main className="flex-1 overflow-y-auto">
          {/* Hero Banner - wine.com Style */}
          <section className="relative bg-gradient-to-r from-primary to-primary/80 py-12 text-primary-foreground">
            <div className="container mx-auto px-4">
              <div className="flex items-center justify-between">
                <div className="max-w-xl">
                  <h1 className="mb-3 text-3xl font-bold md:text-4xl">
                    AI가 추천하는 와인
                  </h1>
                  <p className="mb-6 text-lg text-primary-foreground/90">
                    상황과 취향에 맞는 완벽한 와인을 찾아보세요
                  </p>
                  <Button 
                    size="lg" 
                    variant="outline"
                    onClick={() => setShowChat(true)}
                    className="gap-2 bg-background/20 backdrop-blur-sm border-primary-foreground/30 text-primary-foreground"
                    data-testid="button-hero-chat"
                  >
                    <Sparkles className="h-5 w-5" />
                    AI 소믈리에와 대화하기
                  </Button>
                </div>
                <div className="hidden lg:block">
                  <div className="flex h-40 w-32 items-end justify-center rounded-t-full bg-gradient-to-t from-primary-foreground/20 to-transparent">
                    <div className="mb-4 h-28 w-16 rounded-t-full bg-gradient-to-t from-primary-foreground/30 to-transparent" />
                  </div>
                </div>
              </div>
            </div>
          </section>

          {/* Category Pills - wine.com Style */}
          <section className="border-b border-border bg-background py-4">
            <div className="container mx-auto px-4">
              <div className="flex flex-wrap items-center gap-2">
                {categoryPills.map((cat) => (
                  <Badge
                    key={cat.id}
                    onClick={() => handleCategoryClick(cat.id)}
                    className={`cursor-pointer rounded-full ${
                      filters.type === cat.id 
                        ? cat.color + " ring-2 ring-offset-2 ring-primary" 
                        : cat.color
                    }`}
                    data-testid={`button-category-${cat.id}`}
                  >
                    {cat.label}
                  </Badge>
                ))}
              </div>
            </div>
          </section>

          {/* Mobile Search */}
          <section className="border-b border-border bg-background py-3 md:hidden">
            <div className="container mx-auto px-4">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                <Input
                  placeholder="와인 검색..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10 bg-muted/50 border-0"
                  data-testid="input-search-mobile"
                />
              </div>
            </div>
          </section>

          {/* Trending Section - Vivino Style */}
          {!filters.type && !searchQuery && featuredWines.length > 0 && (
            <section className="py-8 border-b border-border">
              <div className="container mx-auto px-4">
                <div className="mb-4 flex items-center justify-between">
                  <h2 className="text-xl font-bold">인기 와인</h2>
                  <Button variant="ghost" size="sm" className="gap-1 text-primary" data-testid="button-view-all">
                    전체 보기 <ChevronRight className="h-4 w-4" />
                  </Button>
                </div>
                <div className="flex gap-4 overflow-x-auto pb-4 scrollbar-hide">
                  {featuredWines.slice(0, 8).map((wine) => (
                    <div key={wine.id} className="flex-none w-56">
                      <WineCard
                        wine={wine}
                        onClick={() => setSelectedWine(wine)}
                        compact
                      />
                    </div>
                  ))}
                </div>
              </div>
            </section>
          )}

          {/* Filters Section */}
          <section className="border-b border-border bg-card py-4">
            <div className="container mx-auto px-4">
              <div className="flex flex-wrap items-center gap-4">
                <WineFilters filters={filters} onFiltersChange={setFilters} />
                
                {activeFilterCount > 0 && (
                  <Button
                    variant="ghost"
                    size="sm"
                    onClick={clearFilters}
                    className="gap-1 text-muted-foreground"
                    data-testid="button-clear-filters"
                  >
                    <X className="h-4 w-4" />
                    필터 초기화 ({activeFilterCount})
                  </Button>
                )}
              </div>
            </div>
          </section>

          {/* Wine List - Vivino Grid Style */}
          <section className="py-8">
            <div className="container mx-auto px-4">
              <div className="mb-6 flex items-center justify-between">
                <h2 className="text-xl font-bold">
                  {filters.type ? `${categoryPills.find(c => c.id === filters.type)?.label || filters.type}` : "전체 와인"}
                </h2>
                <Badge variant="secondary" data-testid="text-wine-count">
                  {wines.length}개
                </Badge>
              </div>

              {isLoading ? (
                <div className="grid gap-4 grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
                  {Array.from({ length: 10 }).map((_, i) => (
                    <div
                      key={i}
                      className="aspect-[3/4] animate-pulse rounded-lg bg-muted"
                    />
                  ))}
                </div>
              ) : wines.length === 0 ? (
                <div className="py-16 text-center">
                  <Wine className="mx-auto mb-4 h-16 w-16 text-muted-foreground/50" />
                  <h4 className="mb-2 text-lg font-medium">와인을 찾을 수 없습니다</h4>
                  <p className="text-muted-foreground">
                    다른 검색어나 필터를 시도해보세요
                  </p>
                  <Button
                    variant="outline"
                    className="mt-4"
                    onClick={clearFilters}
                    data-testid="button-reset-filters-empty"
                  >
                    필터 초기화
                  </Button>
                </div>
              ) : (
                <div className="grid gap-4 grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
                  {wines.map((wine) => (
                    <WineCard
                      key={wine.id}
                      wine={wine}
                      onClick={() => setSelectedWine(wine)}
                    />
                  ))}
                </div>
              )}
            </div>
          </section>
        </main>

        {/* Chat Panel - Mobile: Full screen overlay, Desktop: Side panel */}
        {showChat && (
          <>
            {/* Mobile/Tablet Full Screen */}
            <aside 
              className="fixed inset-0 z-50 bg-card md:hidden"
            >
              <SommelierChat onClose={() => setShowChat(false)} onSelectWine={setSelectedWine} />
            </aside>

            {/* Desktop Side Panel - Resizable */}
            <aside 
              className="relative hidden md:block flex-shrink-0 border-l border-border bg-card h-full"
              style={{ width: `${chatWidth}px` }}
            >
              {/* Resize Handle */}
              <div
                ref={resizeRef}
                onMouseDown={handleMouseDown}
                onTouchStart={handleTouchStart}
                className={`absolute -left-2 top-0 bottom-0 w-4 cursor-ew-resize z-10 group touch-none`}
                data-testid="resize-handle"
              >
                <div className={`absolute left-1/2 top-0 bottom-0 w-1 -translate-x-1/2 transition-colors ${isResizing ? "bg-primary" : "bg-transparent group-hover:bg-primary/50"}`} />
                <div className="absolute left-1/2 top-1/2 -translate-y-1/2 -translate-x-1/2 flex h-12 w-5 items-center justify-center rounded-full bg-muted border border-border shadow-sm opacity-0 group-hover:opacity-100 transition-opacity">
                  <GripVertical className="h-4 w-4 text-muted-foreground" />
                </div>
              </div>
              <SommelierChat onClose={() => setShowChat(false)} onSelectWine={setSelectedWine} />
            </aside>
          </>
        )}
      </div>

      {/* Wine Detail Modal */}
      <WineDetailModal
        wine={selectedWine}
        onClose={() => setSelectedWine(null)}
      />

      {/* Auth Modal */}
      <AuthModal
        isOpen={showAuthModal}
        onClose={() => setShowAuthModal(false)}
      />
    </div>
  );
}
