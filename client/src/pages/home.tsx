import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Wine, MessageSquare, Search, Filter, X, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { WineCard } from "@/components/wine-card";
import { WineFilters } from "@/components/wine-filters";
import { SommelierChat } from "@/components/sommelier-chat";
import { WineDetailModal } from "@/components/wine-detail-modal";
import { ThemeToggle } from "@/components/theme-toggle";
import type { Wine as WineType } from "@shared/schema";

export default function Home() {
  const [showChat, setShowChat] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedWine, setSelectedWine] = useState<WineType | null>(null);
  const [filters, setFilters] = useState<{
    type?: string;
    nation?: string;
    occasion?: string;
    priceMin?: number;
    priceMax?: number;
  }>({});

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

  const activeFilterCount = Object.values(filters).filter(Boolean).length;

  const clearFilters = () => {
    setFilters({});
    setSearchQuery("");
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="sticky top-0 z-50 border-b border-border bg-sidebar text-sidebar-foreground">
        <div className="container mx-auto px-4 py-4">
          <div className="flex items-center justify-between gap-4">
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary">
                <Wine className="h-5 w-5 text-primary-foreground" />
              </div>
              <div>
                <h1 className="text-xl font-bold tracking-tight">AI Wine Sommelier</h1>
                <p className="text-xs text-sidebar-foreground/70">Your Personal Wine Expert</p>
              </div>
            </div>
            
            <div className="flex items-center gap-3">
              <ThemeToggle />
              <Button
                onClick={() => setShowChat(!showChat)}
                variant={showChat ? "default" : "outline"}
                className="gap-2"
                data-testid="button-toggle-chat"
              >
                <Sparkles className="h-4 w-4" />
                <span className="hidden sm:inline">AI 소믈리에</span>
              </Button>
            </div>
          </div>
        </div>
      </header>

      <div className="flex">
        {/* Main Content */}
        <main className={`flex-1 transition-all duration-300 ${showChat ? "mr-96" : ""}`}>
          {/* Hero Section */}
          <section className="relative overflow-hidden bg-gradient-to-br from-sidebar via-sidebar to-primary/20 py-16 text-sidebar-foreground">
            <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48ZyBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPjxnIGZpbGw9IiNmZmYiIGZpbGwtb3BhY2l0eT0iMC4wMyI+PGNpcmNsZSBjeD0iMzAiIGN5PSIzMCIgcj0iMiIvPjwvZz48L2c+PC9zdmc+')] opacity-50" />
            <div className="container relative mx-auto px-4 text-center">
              <h2 className="mb-4 font-serif text-4xl font-bold md:text-5xl">
                당신만을 위한 와인 추천
              </h2>
              <p className="mx-auto mb-8 max-w-2xl text-lg text-sidebar-foreground/80">
                AI 소믈리에가 상황과 취향에 맞는 완벽한 와인을 추천해드립니다
              </p>
              
              {/* Search Bar */}
              <div className="mx-auto flex max-w-xl gap-2">
                <div className="relative flex-1">
                  <Search className="absolute left-3 top-1/2 h-5 w-5 -translate-y-1/2 text-muted-foreground" />
                  <Input
                    placeholder="와인 이름, 품종, 국가로 검색..."
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="h-12 pl-10 bg-background/95 text-foreground border-0"
                    data-testid="input-search"
                  />
                </div>
                <Button size="lg" className="h-12 px-6" data-testid="button-search">
                  검색
                </Button>
              </div>
            </div>
          </section>

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

          {/* Wine List */}
          <section className="py-8">
            <div className="container mx-auto px-4">
              <div className="mb-6 flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <h3 className="text-xl font-semibold">와인 목록</h3>
                  <Badge variant="secondary" data-testid="text-wine-count">
                    {wines.length}개
                  </Badge>
                </div>
              </div>

              {isLoading ? (
                <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                  {Array.from({ length: 8 }).map((_, i) => (
                    <div
                      key={i}
                      className="h-80 animate-pulse rounded-lg bg-muted"
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
                  >
                    필터 초기화
                  </Button>
                </div>
              ) : (
                <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
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

        {/* Chat Sidebar */}
        {showChat && (
          <aside className="fixed right-0 top-0 z-40 h-screen w-96 border-l border-border bg-card shadow-xl">
            <SommelierChat onClose={() => setShowChat(false)} onSelectWine={setSelectedWine} />
          </aside>
        )}
      </div>

      {/* Wine Detail Modal */}
      <WineDetailModal
        wine={selectedWine}
        onClose={() => setSelectedWine(null)}
      />
    </div>
  );
}
