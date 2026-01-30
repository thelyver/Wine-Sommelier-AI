import { X, Star, MapPin, Grape, Wine as WineIcon, Droplets, Flame, Leaf, Clock } from "lucide-react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
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

  const tastingAttributes = [
    { label: "당도", value: wine.sweet, icon: Droplets, color: "bg-pink-500" },
    { label: "산도", value: wine.acidity, icon: Leaf, color: "bg-green-500" },
    { label: "바디", value: wine.body, icon: WineIcon, color: "bg-purple-500" },
    { label: "탄닌", value: wine.tannin, icon: Flame, color: "bg-orange-500" },
  ].filter((attr) => attr.value !== null && attr.value !== undefined);

  return (
    <Dialog open={!!wine} onOpenChange={() => onClose()}>
      <DialogContent className="max-w-2xl max-h-[90vh] p-0 overflow-hidden" data-testid="modal-wine-detail">
        <ScrollArea className="max-h-[90vh]">
          <div className="p-6">
            <DialogHeader className="mb-6">
              <div className="flex items-start justify-between gap-4">
                <div className="flex-1">
                  {wine.type && (
                    <Badge className={`mb-2 ${typeColors[wine.type] || "bg-muted"}`}>
                      {typeLabels[wine.type] || wine.type}
                    </Badge>
                  )}
                  <DialogTitle className="text-2xl font-serif leading-tight">
                    {wine.nameKr}
                  </DialogTitle>
                  {wine.nameEn && (
                    <p className="mt-1 text-sm text-muted-foreground">{wine.nameEn}</p>
                  )}
                </div>
                {wine.vivinoRating && (
                  <div className="flex flex-col items-center rounded-lg bg-muted px-4 py-2">
                    <div className="flex items-center gap-1">
                      <Star className="h-5 w-5 fill-amber-400 text-amber-400" />
                      <span className="text-2xl font-bold">{wine.vivinoRating}</span>
                    </div>
                    <span className="text-xs text-muted-foreground">Vivino</span>
                  </div>
                )}
              </div>
            </DialogHeader>

            {/* Wine Info Grid */}
            <div className="grid gap-4 sm:grid-cols-2 mb-6">
              <div className="space-y-3">
                {wine.producer && (
                  <div className="flex items-center gap-2 text-sm">
                    <WineIcon className="h-4 w-4 text-muted-foreground" />
                    <span className="text-muted-foreground">생산자:</span>
                    <span className="font-medium">{wine.producer}</span>
                  </div>
                )}
                {wine.nation && (
                  <div className="flex items-center gap-2 text-sm">
                    <MapPin className="h-4 w-4 text-muted-foreground" />
                    <span className="text-muted-foreground">국가:</span>
                    <span className="font-medium">{wine.nation}</span>
                    {wine.region && <span className="text-muted-foreground">/ {wine.region}</span>}
                  </div>
                )}
                {wine.varieties && (
                  <div className="flex items-center gap-2 text-sm">
                    <Grape className="h-4 w-4 text-muted-foreground" />
                    <span className="text-muted-foreground">품종:</span>
                    <span className="font-medium">{wine.varieties.trim()}</span>
                  </div>
                )}
              </div>
              <div className="space-y-3">
                {wine.year && (
                  <div className="flex items-center gap-2 text-sm">
                    <Clock className="h-4 w-4 text-muted-foreground" />
                    <span className="text-muted-foreground">빈티지:</span>
                    <span className="font-medium">{wine.year}</span>
                  </div>
                )}
                {wine.abv && (
                  <div className="flex items-center gap-2 text-sm">
                    <Flame className="h-4 w-4 text-muted-foreground" />
                    <span className="text-muted-foreground">도수:</span>
                    <span className="font-medium">{wine.abv}%</span>
                  </div>
                )}
                <div className="flex items-center gap-2 text-sm">
                  <span className="text-2xl font-bold text-primary">{formatPrice(wine.price)}</span>
                </div>
              </div>
            </div>

            <Separator className="my-6" />

            {/* Tasting Profile */}
            {tastingAttributes.length > 0 && (
              <div className="mb-6">
                <h4 className="mb-4 font-semibold">테이스팅 프로필</h4>
                <div className="grid gap-4 sm:grid-cols-2">
                  {tastingAttributes.map((attr) => (
                    <div key={attr.label} className="space-y-2">
                      <div className="flex items-center justify-between text-sm">
                        <div className="flex items-center gap-2">
                          <attr.icon className="h-4 w-4 text-muted-foreground" />
                          <span>{attr.label}</span>
                        </div>
                        <span className="font-medium">{attr.value}/5</span>
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

            {/* Summary */}
            {wine.summary && (
              <div className="mb-6">
                <h4 className="mb-2 font-semibold">한줄 요약</h4>
                <p className="text-muted-foreground">{wine.summary}</p>
              </div>
            )}

            {/* Description */}
            {wine.description && (
              <div className="mb-6">
                <h4 className="mb-2 font-semibold">상세 설명</h4>
                <p className="text-sm text-muted-foreground whitespace-pre-line">
                  {wine.description}
                </p>
              </div>
            )}

            {/* Tasting Note */}
            {wine.tastingNote && (
              <div className="mb-6">
                <h4 className="mb-2 font-semibold">테이스팅 노트</h4>
                <p className="text-sm text-muted-foreground">{wine.tastingNote}</p>
              </div>
            )}

            {/* Pairing */}
            {wine.pairing && (
              <div className="mb-6">
                <h4 className="mb-2 font-semibold">페어링 추천</h4>
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
              <div>
                <h4 className="mb-2 font-semibold">추천 상황</h4>
                <div className="flex flex-wrap gap-2">
                  {wine.occasionTags.split("|").map((tag, i) => (
                    <Badge key={i} variant="outline">
                      {tag.trim()}
                    </Badge>
                  ))}
                </div>
              </div>
            )}
          </div>
        </ScrollArea>
      </DialogContent>
    </Dialog>
  );
}
