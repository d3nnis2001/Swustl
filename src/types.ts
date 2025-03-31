export enum MatchStatus {
    NEW = "NEU",
    FAVORITE = "FAVORIT",
    SUPER_LIKE = "SUPER LIKE",
    MATCHED = "MATCHED",
    UNAVAILABLE = "NICHT VERFÜGBAR"
  }
  
  export interface ProfileType {
    id: number;
    name: string;
    age: number;
    bio: string;
    images: string[];
    status: MatchStatus;
  }
  
  export interface SwipeHandlers {
    onNext: () => void;
  }
  
  export type SwipeDirection = 'left' | 'right' | null;
  
  export interface LynxTouchEvent {
    touches: Array<{clientX: number; clientY: number}>;
    stopPropagation: () => void;
  }