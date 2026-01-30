import { Star, Plus } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import type { Wine as WineType } from "@shared/schema";

interface WineCardProps {
  wine: WineType;
  onClick: () => void;
  compact?: boolean;
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

export function WineCard({ wine, onClick, compact = false }: WineCardProps) {
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

  const imageUrl = `/wine-images/${wine.id}.png`;

  if (compact) {
    return (
      <Card
        className="group cursor-pointer overflow-hidden transition-all hover:shadow-md hover-elevate border-0 bg-transparent"
        onClick={onClick}
        data-testid={`card-wine-${wine.id}`}
      >
        <CardContent className="p-0">
          <div className="relative flex flex-col items-center p-4 bg-card rounded-lg">
            {/* Wine Bottle Image */}
            <div className="relative h-32 w-20 mb-3 flex items-end justify-center">
              <img 
                src={imageUrl} 
                alt={wine.nameKr || wine.nameEn || "Wine"} 
                className="h-full w-auto object-contain"
                onError={(e) => {
                  e.currentTarget.style.display = 'none';
                  e.currentTarget.nextElementSibling?.classList.remove('hidden');
                }}
              />
              <div className={`hidden absolute inset-0 flex items-end justify-center`}>
                <div className={`h-28 w-10 rounded-t-full bg-gradient-to-b ${bottleColor} shadow-lg`}>
                  <div className="absolute -top-2 left-1/2 -translate-x-1/2 h-4 w-3 bg-amber-800 rounded-t-sm" />
                </div>
              </div>
            </div>
            
            {/* Producer */}
            <p className="text-xs text-muted-foreground text-center mb-1 line-clamp-1">
              {wine.producer}
            </p>
            
            {/* Name */}
            <h3 className="text-sm font-medium text-center line-clamp-2 mb-2">
              {wine.nameKr?.split(" ").slice(0, 3).join(" ")}
            </h3>
            
            {/* Rating */}
            {rating && (
              <div className="flex items-center gap-1 mb-2">
                <Star className="h-3.5 w-3.5 fill-primary text-primary" />
                <span className="text-sm font-semibold">{rating}</span>
              </div>
            )}
            
            {/* Price */}
            <span className="text-sm font-bold text-foreground">
              {formatPrice(wine.price)}
            </span>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card
      className="group cursor-pointer overflow-hidden transition-all hover:shadow-lg hover-elevate"
      onClick={onClick}
      data-testid={`card-wine-${wine.id}`}
    >
      <CardContent className="p-0">
        {/* Wine Image Area - Vivino Style */}
        <div className="relative flex flex-col items-center pt-6 pb-4 px-4 bg-gradient-to-b from-muted/30 to-transparent">
          {/* Type Badge - Top Left */}
          {wine.type && (
            <Badge
              className={`absolute left-2 top-2 text-xs ${typeColors[wine.type] || "bg-muted"}`}
              data-testid={`badge-type-${wine.id}`}
            >
              {typeLabels[wine.type] || wine.type}
            </Badge>
          )}
          
          {/* Wine Bottle Image */}
          <div className="relative h-40 w-24 flex items-end justify-center">
            <img 
              src={imageUrl} 
              alt={wine.nameKr || wine.nameEn || "Wine"} 
              className="h-full w-auto object-contain"
              onError={(e) => {
                e.currentTarget.style.display = 'none';
                e.currentTarget.nextElementSibling?.classList.remove('hidden');
              }}
            />
            <div className={`hidden absolute inset-0 flex items-end justify-center`}>
              <div className={`h-36 w-14 rounded-t-full bg-gradient-to-b ${bottleColor} shadow-lg relative`}>
                <div className="absolute -top-3 left-1/2 -translate-x-1/2 h-5 w-4 bg-amber-800 rounded-t-sm" />
                {wine.year && wine.year !== "non-vintage" && (
                  <div className="absolute bottom-8 left-1/2 -translate-x-1/2 text-[8px] text-white/80 font-medium">
                    {wine.year}
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Content - Vivino Style */}
        <div className="p-4 space-y-2">
          {/* Producer */}
          <p className="text-xs text-muted-foreground line-clamp-1">
            {wine.producer}
          </p>
          
          {/* Wine Name */}
          <h3 className="font-medium leading-snug line-clamp-2 min-h-[2.5rem]">
            {wine.nameKr}
          </h3>

          {/* Region & Variety */}
          <p className="text-xs text-muted-foreground line-clamp-1">
            {wine.nation}{wine.region ? ` · ${wine.region.split(" ")[0]}` : ""}
          </p>

          {/* Rating - Vivino Style */}
          {rating && (
            <div className="flex items-center gap-2 py-2">
              <div className="flex items-center gap-1 bg-primary/10 rounded-full px-2 py-1">
                <Star className="h-4 w-4 fill-primary text-primary" />
                <span className="text-sm font-bold text-primary">{rating}</span>
              </div>
              <span className="text-xs text-muted-foreground">
                평점
              </span>
            </div>
          )}

          {/* Price & Add Button */}
          <div className="flex items-center justify-between pt-2 border-t border-border">
            <span className="text-lg font-bold">
              {formatPrice(wine.price)}
            </span>
            <Button
              size="sm"
              variant="outline"
              className="gap-1"
              onClick={(e) => {
                e.stopPropagation();
                onClick();
              }}
              data-testid={`button-view-${wine.id}`}
            >
              <Plus className="h-4 w-4" />
              상세
            </Button>
          </div>
        </div>
      </CardContent>
    </Card>
  );
}
