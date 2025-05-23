export interface Comment {
  id: string;
  content: string;
  userId: string;
  novelId: string;
  chapterId?: string;
  parentId?: string;
  likes: number;
  isReported: boolean;
  createdAt: Date;
  updatedAt: Date;
  status: 'active' | 'hidden' | 'reported';
} 