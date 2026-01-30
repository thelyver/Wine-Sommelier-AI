import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { ChevronDown, Wine, Globe, Calendar, Banknote, Check } from "lucide-react";

interface FiltersState {
  type?: string;
  nation?: string;
  occasion?: string;
  priceMin?: number;
  priceMax?: number;
}

interface WineFiltersProps {
  filters: FiltersState;
  onFiltersChange: (filters: FiltersState) => void;
}

const wineTypes = [
  { value: "RED", label: "레드", icon: "🍷" },
  { value: "WHITE", label: "화이트", icon: "🥂" },
  { value: "SPARKLING", label: "스파클링", icon: "🍾" },
  { value: "Rose", label: "로제", icon: "🌸" },
  { value: "Fortified", label: "주정강화", icon: "🥃" },
];

const nations = [
  { value: "France", label: "프랑스" },
  { value: "Italy", label: "이탈리아" },
  { value: "Spain", label: "스페인" },
  { value: "USA", label: "미국" },
  { value: "Chile", label: "칠레" },
  { value: "Australia", label: "호주" },
  { value: "New Zealand", label: "뉴질랜드" },
  { value: "Germany", label: "독일" },
  { value: "Portugal", label: "포르투갈" },
  { value: "Argentina", label: "아르헨티나" },
];

const occasions = [
  { value: "데일리", label: "데일리" },
  { value: "데이트", label: "데이트" },
  { value: "파티", label: "파티" },
  { value: "혼술", label: "혼술" },
  { value: "선물", label: "선물" },
  { value: "대화용", label: "대화용" },
  { value: "피크닉", label: "피크닉" },
  { value: "행사", label: "행사" },
];

const priceRanges = [
  { min: 0, max: 30000, label: "3만원 이하" },
  { min: 30000, max: 50000, label: "3~5만원" },
  { min: 50000, max: 100000, label: "5~10만원" },
  { min: 100000, max: 200000, label: "10~20만원" },
  { min: 200000, max: 10000000, label: "20만원 이상" },
];

export function WineFilters({ filters, onFiltersChange }: WineFiltersProps) {
  const updateFilter = (key: keyof FiltersState, value: any) => {
    if (filters[key] === value) {
      const { [key]: _, ...rest } = filters;
      onFiltersChange(rest as FiltersState);
    } else {
      onFiltersChange({ ...filters, [key]: value });
    }
  };

  const updatePriceFilter = (min: number, max: number) => {
    if (filters.priceMin === min && filters.priceMax === max) {
      const { priceMin: _, priceMax: __, ...rest } = filters;
      onFiltersChange(rest as FiltersState);
    } else {
      onFiltersChange({ ...filters, priceMin: min, priceMax: max });
    }
  };

  const getPriceLabel = () => {
    if (filters.priceMin === undefined) return "가격대";
    const range = priceRanges.find(
      (r) => r.min === filters.priceMin && r.max === filters.priceMax
    );
    return range?.label || "가격대";
  };

  return (
    <div className="flex flex-wrap items-center gap-2">
      {/* Type Filter */}
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button
            variant={filters.type ? "default" : "outline"}
            size="sm"
            className="gap-2"
            data-testid="button-filter-type"
          >
            <Wine className="h-4 w-4" />
            {filters.type ? wineTypes.find((t) => t.value === filters.type)?.label : "타입"}
            <ChevronDown className="h-3 w-3" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="start">
          {wineTypes.map((type) => (
            <DropdownMenuItem
              key={type.value}
              onClick={() => updateFilter("type", type.value)}
              className="gap-2"
              data-testid={`menu-type-${type.value}`}
            >
              <span>{type.icon}</span>
              <span>{type.label}</span>
              {filters.type === type.value && <Check className="ml-auto h-4 w-4" />}
            </DropdownMenuItem>
          ))}
        </DropdownMenuContent>
      </DropdownMenu>

      {/* Nation Filter */}
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button
            variant={filters.nation ? "default" : "outline"}
            size="sm"
            className="gap-2"
            data-testid="button-filter-nation"
          >
            <Globe className="h-4 w-4" />
            {filters.nation ? nations.find((n) => n.value === filters.nation)?.label : "국가"}
            <ChevronDown className="h-3 w-3" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="start" className="max-h-64 overflow-y-auto">
          {nations.map((nation) => (
            <DropdownMenuItem
              key={nation.value}
              onClick={() => updateFilter("nation", nation.value)}
              data-testid={`menu-nation-${nation.value}`}
            >
              {nation.label}
              {filters.nation === nation.value && <Check className="ml-auto h-4 w-4" />}
            </DropdownMenuItem>
          ))}
        </DropdownMenuContent>
      </DropdownMenu>

      {/* Occasion Filter */}
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button
            variant={filters.occasion ? "default" : "outline"}
            size="sm"
            className="gap-2"
            data-testid="button-filter-occasion"
          >
            <Calendar className="h-4 w-4" />
            {filters.occasion || "상황"}
            <ChevronDown className="h-3 w-3" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="start">
          {occasions.map((occasion) => (
            <DropdownMenuItem
              key={occasion.value}
              onClick={() => updateFilter("occasion", occasion.value)}
              data-testid={`menu-occasion-${occasion.value}`}
            >
              {occasion.label}
              {filters.occasion === occasion.value && <Check className="ml-auto h-4 w-4" />}
            </DropdownMenuItem>
          ))}
        </DropdownMenuContent>
      </DropdownMenu>

      {/* Price Filter */}
      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button
            variant={filters.priceMin !== undefined ? "default" : "outline"}
            size="sm"
            className="gap-2"
            data-testid="button-filter-price"
          >
            <Banknote className="h-4 w-4" />
            {getPriceLabel()}
            <ChevronDown className="h-3 w-3" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="start">
          {priceRanges.map((range) => (
            <DropdownMenuItem
              key={range.label}
              onClick={() => updatePriceFilter(range.min, range.max)}
              data-testid={`menu-price-${range.label}`}
            >
              {range.label}
              {filters.priceMin === range.min && filters.priceMax === range.max && (
                <Check className="ml-auto h-4 w-4" />
              )}
            </DropdownMenuItem>
          ))}
        </DropdownMenuContent>
      </DropdownMenu>
    </div>
  );
}
