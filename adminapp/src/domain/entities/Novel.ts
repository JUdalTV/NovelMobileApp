export interface Novel {
  id: string;
  title: string;
  slug: string;
  description: string;
  author: string;
  coverImage: string;
  categories: string[];
  tags: string[];
  status: 'ongoing' | 'completed' | 'hiatus';
  totalChapters: number;
  views: number;
  rating: number;
  totalRatings: number;
  createdAt: string;
  updatedAt: string;
} 

export type NovelStatus = 'ongoing' | 'completed' | 'hiatus';
export type NovelFormData = Omit<Novel, 'id' | 'createdAt' | 'updatedAt' | 'slug'>; 