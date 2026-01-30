import { Star, MapPin, Grape, Wine as WineIcon, Droplets, Flame, Leaf, Clock, UtensilsCrossed, Tag, X } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogClose,
} from "@/components/ui/dialog";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import { Separator } from "@/components/ui/separator";
import { ScrollArea } from "@/components/ui/scroll-area";
import type { Wine } from "@shared/schema";

interface WineDetailModalProps {
  wine: Wine | null;
  onClose: () => void;
}

const typeColors: Record<string, string> = {
  RED: "bg-rose-600 text-white",
  WHITE: "bg-amber-100 text-amber-800 dark:bg-amber-900 dark:text-amber-100",
  SPARKLING: "bg-cyan-100 text-cyan-800 dark:bg-cyan-900 dark:text-cyan-100",
  Rose: "bg-pink-200 text-pink-800 dark:bg-pink-900 dark:text-pink-100",
  Fortified: "bg-purple-600 text-white",
};

const typeLabels: Record<string, string> = {
  RED: "레드",
  WHITE: "화이트",
  SPARKLING: "스파클링",
  Rose: "로제",
  Fortified: "주정강화",
};

const wineBottleColors: Record<string, string> = {
  RED: "from-rose-900 to-rose-700",
  WHITE: "from-amber-200 to-amber-100",
  SPARKLING: "from-amber-300 to-amber-100",
  Rose: "from-pink-400 to-pink-200",
  Fortified: "from-amber-900 to-amber-700",
};

export function WineDetailModal({ wine, onClose }: WineDetailModalProps) {
  if (!wine) return null;

  const formatPrice = (price: number | null) => {
    if (!price) return "가격 미정";
    return new Intl.NumberFormat("ko-KR", {
      style: "currency",
      currency: "KRW",
      maximumFractionDigits: 0,
    }).format(price);
  };

  const rating = wine.vivinoRating;
  const bottleColor = wineBottleColors[wine.type || "RED"] || wineBottleColors.RED;

  const tastingAttributes = [
    { label: "당도", value: wine.sweet, icon: Droplets, color: "bg-pink-500", description: "단맛의 정도" },
    { label: "산도", value: wine.acidity, icon: Leaf, color: "bg-green-500", description: "신맛의 정도" },
    { label: "바디", value: wine.body, icon: WineIcon, color: "bg-purple-500", description: "와인의 무게감" },
    { label: "탄닌", value: wine.tannin, icon: Flame, color: "bg-orange-500", description: "떫은맛의 정도" },
  ].filter((attr) => attr.value !== null && attr.value !== undefined);

  return (
    <Dialog open={!!wine} onOpenChange={() => onClose()}>
      <DialogContent className="max-w-xl max-h-[90vh] p-0 overflow-hidden gap-0" data-testid="modal-wine-detail">
        {/* Header with Wine Image - Vivino Style */}
        <div className="relative bg-gradient-to-b from-muted to-background p-6 pb-4">
          {/* Explicit Close Button */}
          <DialogClose asChild>
            <Button
              size="icon"
              variant="ghost"
              className="absolute right-4 top-4 rounded-full bg-background/80 backdrop-blur-sm"
              data-testid="button-close-modal"
            >
              <X className="h-4 w-4" />
              <span className="sr-only">Close</span>
            </Button>
          </DialogClose>
          <div className="flex gap-6">
            {/* Wine Bottle */}
            <div className="flex-shrink-0">
              <div className={`relative h-40 w-16 rounded-t-full bg-gradient-to-b ${bottleColor} shadow-xl`}>
                <div className="absolute -top-3 left-1/2 -translate-x-1/2 h-5 w-4 bg-amber-800 rounded-t-sm" />
                {wine.year && wine.year !== "non-vintage" && (
                  <div className="absolute bottom-10 left-1/2 -translate-x-1/2 text-[10px] text-white/80 font-medium">
                    {wine.year}
                  </div>
                )}
              </div>
            </div>

            {/* Wine Info */}
            <div className="flex-1 min-w-0">
              {wine.type && (
                <Badge className={`mb-2 ${typeColors[wine.type] || "bg-muted"}`}>
                  {typeLabels[wine.type] || wine.type}
                </Badge>
              )}
              
              <h2 className="text-xl font-bold leading-tight mb-1">
                {wine.nameKr}
              </h2>
              
              {wine.producer && (
                <p className="text-sm text-muted-foreground mb-3">{wine.producer}</p>
              )}

              {/* Rating - Vivino Style */}
              {rating && (
                <div className="flex items-center gap-3 mb-3">
                  <div className="flex items-center gap-1 bg-primary/10 rounded-lg px-3 py-2">
                    <Star className="h-5 w-5 fill-primary text-primary" />
                    <span className="text-xl font-bold text-primary">{rating}</span>
                  </div>
                  <span className="text-sm text-muted-foreground">평점</span>
                </div>
              )}

              {/* Price */}
              <div className="text-2xl font-bold">{formatPrice(wine.price)}</div>
            </div>
          </div>
        </div>

        {/* Tabs - Using shadcn Tabs Component */}
        <Tabs defaultValue="overview" className="flex flex-col">
          <TabsList className="w-full justify-start rounded-none border-b bg-transparent px-6">
            <TabsTrigger 
              value="overview" 
              className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent"
              data-testid="tab-overview"
            >
              개요
            </TabsTrigger>
            <TabsTrigger 
              value="taste" 
              className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent"
              data-testid="tab-taste"
            >
              테이스팅
            </TabsTrigger>
            <TabsTrigger 
              value="pairing" 
              className="rounded-none border-b-2 border-transparent data-[state=active]:border-primary data-[state=active]:bg-transparent"
              data-testid="tab-pairing"
            >
              페어링
            </TabsTrigger>
          </TabsList>

          <ScrollArea className="flex-1 max-h-[50vh]">
            <TabsContent value="overview" className="mt-0 p-6">
              <div className="space-y-6">
                {/* Wine Details */}
                <div className="grid gap-3">
                  {wine.nation && (
                    <div className="flex items-center gap-3 text-sm">
                      <MapPin className="h-4 w-4 text-muted-foreground flex-shrink-0" />
                      <span className="text-muted-foreground">지역:</span>
                      <span className="font-medium">{wine.nation}{wine.region ? ` · ${wine.region}` : ""}</span>
                    </div>
                  )}
                  {wine.varieties && (
                    <div className="flex items-center gap-3 text-sm">
                      <Grape className="h-4 w-4 text-muted-foreground flex-shrink-0" />
                      <span className="text-muted-foreground">품종:</span>
                      <span className="font-medium">{wine.varieties.trim()}</span>
                    </div>
                  )}
                  {wine.abv && (
                    <div className="flex items-center gap-3 text-sm">
                      <Flame className="h-4 w-4 text-muted-foreground flex-shrink-0" />
                      <span className="text-muted-foreground">도수:</span>
                      <span className="font-medium">{wine.abv}%</span>
                    </div>
                  )}
                  {wine.year && (
                    <div className="flex items-center gap-3 text-sm">
                      <Clock className="h-4 w-4 text-muted-foreground flex-shrink-0" />
                      <span className="text-muted-foreground">빈티지:</span>
                      <span className="font-medium">{wine.year}</span>
                    </div>
                  )}
                </div>

                {/* Summary */}
                {wine.summary && (
                  <>
                    <Separator />
                    <div>
                      <h4 className="font-semibold mb-2">한줄 요약</h4>
                      <p className="text-sm text-muted-foreground">{wine.summary}</p>
                    </div>
                  </>
                )}

                {/* Description */}
                {wine.description && (
                  <div>
                    <h4 className="font-semibold mb-2">상세 설명</h4>
                    <p className="text-sm text-muted-foreground whitespace-pre-line leading-relaxed">
                      {wine.description}
                    </p>
                  </div>
                )}
              </div>
            </TabsContent>

            <TabsContent value="taste" className="mt-0 p-6">
              <div className="space-y-6">
                {/* Tasting Profile */}
                {tastingAttributes.length > 0 && (
                  <div>
                    <h4 className="font-semibold mb-4">테이스팅 프로필</h4>
                    <div className="space-y-4">
                      {tastingAttributes.map((attr) => (
                        <div key={attr.label} className="space-y-2">
                          <div className="flex items-center justify-between">
                            <div className="flex items-center gap-2">
                              <div className={`h-8 w-8 rounded-full ${attr.color} flex items-center justify-center`}>
                                <attr.icon className="h-4 w-4 text-white" />
                              </div>
                              <div>
                                <div className="font-medium text-sm">{attr.label}</div>
                                <div className="text-xs text-muted-foreground">{attr.description}</div>
                              </div>
                            </div>
                            <span className="font-bold">{attr.value}/5</span>
                          </div>
                          <Progress 
                            value={((attr.value || 0) / 5) * 100} 
                            className="h-2"
                          />
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {/* Tasting Note */}
                {wine.tastingNote && (
                  <>
                    <Separator />
                    <div>
                      <h4 className="font-semibold mb-2">테이스팅 노트</h4>
                      <p className="text-sm text-muted-foreground leading-relaxed">{wine.tastingNote}</p>
                    </div>
                  </>
                )}
              </div>
            </TabsContent>

            <TabsContent value="pairing" className="mt-0 p-6">
              <div className="space-y-6">
                {/* Pairing */}
                {wine.pairing && (
                  <div>
                    <div className="flex items-center gap-2 mb-4">
                      <UtensilsCrossed className="h-5 w-5 text-primary" />
                      <h4 className="font-semibold">음식 페어링</h4>
                    </div>
                    <div className="flex flex-wrap gap-2">
                      {wine.pairing.split(",").map((item, i) => (
                        <Badge key={i} variant="secondary">
                          {item.trim()}
                        </Badge>
                      ))}
                    </div>
                  </div>
                )}

                {/* Occasion Tags */}
                {wine.occasionTags && (
                  <>
                    <Separator />
                    <div>
                      <div className="flex items-center gap-2 mb-4">
                        <Tag className="h-5 w-5 text-primary" />
                        <h4 className="font-semibold">추천 상황</h4>
                      </div>
                      <div className="flex flex-wrap gap-2">
                        {wine.occasionTags.split("|").map((tag, i) => (
                          <Badge key={i} variant="outline">
                            {tag.trim()}
                          </Badge>
                        ))}
                      </div>
                    </div>
                  </>
                )}

                {!wine.pairing && !wine.occasionTags && (
                  <div className="text-center py-8 text-muted-foreground">
                    <UtensilsCrossed className="h-12 w-12 mx-auto mb-3 opacity-50" />
                    <p>페어링 정보가 없습니다</p>
                  </div>
                )}
              </div>
            </TabsContent>
          </ScrollArea>
        </Tabs>
      </DialogContent>
    </Dialog>
  );
}
