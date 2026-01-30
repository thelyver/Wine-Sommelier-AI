import { Wine, Star, MapPin, Grape } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import type { Wine as WineType } from "@shared/schema";

interface WineCardProps {
  wine: WineType;
  onClick: () => void;
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

export function WineCard({ wine, onClick }: WineCardProps) {
  const formatPrice = (price: number | null) => {
    if (!price) return "가격 미정";
    return new Intl.NumberFormat("ko-KR", {
      style: "currency",
      currency: "KRW",
      maximumFractionDigits: 0,
    }).format(price);
  };

  return (
    <Card
      className="group cursor-pointer overflow-hidden transition-all hover:shadow-lg hover-elevate"
      onClick={onClick}
      data-testid={`card-wine-${wine.id}`}
    >
      <CardContent className="p-0">
        {/* Wine Image Area */}
        <div className="relative flex h-48 items-center justify-center bg-gradient-to-br from-primary/5 to-primary/10">
          <div className="flex h-32 w-20 items-end justify-center rounded-t-full bg-gradient-to-t from-primary/80 to-primary/40">
            <div className="mb-2 h-20 w-12 rounded-t-full bg-gradient-to-t from-primary/60 to-primary/30" />
          </div>
          
          {/* Type Badge */}
          {wine.type && (
            <Badge
              className={`absolute left-3 top-3 ${typeColors[wine.type] || "bg-muted"}`}
              data-testid={`badge-type-${wine.id}`}
            >
              {typeLabels[wine.type] || wine.type}
            </Badge>
          )}
          
          {/* Rating */}
          {wine.vivinoRating && (
            <div className="absolute right-3 top-3 flex items-center gap-1 rounded-full bg-background/90 px-2 py-1 text-sm font-medium backdrop-blur-sm">
              <Star className="h-3.5 w-3.5 fill-amber-400 text-amber-400" />
              {wine.vivinoRating}
            </div>
          )}
        </div>

        {/* Content */}
        <div className="space-y-3 p-4">
          {/* Name */}
          <div>
            <h3 className="line-clamp-2 font-medium leading-snug group-hover:text-primary">
              {wine.nameKr}
            </h3>
            {wine.nameEn && (
              <p className="mt-1 line-clamp-1 text-xs text-muted-foreground">
                {wine.nameEn}
              </p>
            )}
          </div>

          {/* Details */}
          <div className="flex flex-wrap gap-2 text-xs text-muted-foreground">
            {wine.nation && (
              <span className="flex items-center gap-1">
                <MapPin className="h-3 w-3" />
                {wine.nation}
              </span>
            )}
            {wine.varieties && (
              <span className="flex items-center gap-1">
                <Grape className="h-3 w-3" />
                {wine.varieties.trim()}
              </span>
            )}
          </div>

          {/* Summary */}
          {wine.summary && (
            <p className="line-clamp-2 text-sm text-muted-foreground">
              {wine.summary}
            </p>
          )}

          {/* Price */}
          <div className="flex items-center justify-between pt-2 border-t border-border">
            <span className="text-lg font-bold text-primary">
              {formatPrice(wine.price)}
            </span>
            {wine.year && wine.year !== "non-vintage" && (
              <span className="text-sm text-muted-foreground">{wine.year}</span>
            )}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
