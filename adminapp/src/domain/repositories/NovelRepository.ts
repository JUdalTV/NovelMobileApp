import { Novel } from '../entities/Novel';

export interface NovelRepository {
  getNovels(): Promise<Novel[]>;
  getNovelById(id: string): Promise<Novel>;
  createNovel(novel: Omit<Novel, 'id' | 'createdAt' | 'updatedAt'>): Promise<Novel>;
  updateNovel(id: string, novel: Partial<Novel>): Promise<Novel>;
  deleteNovel(id: string): Promise<void>;
  getNovelStats(): Promise<{
    totalNovels: number;
    totalViews: number;
    averageRating: number;
  }>;
} 