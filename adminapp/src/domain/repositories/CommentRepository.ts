import { Comment } from '../entities/Comment';

export interface CommentRepository {
  getComments(): Promise<Comment[]>;
  getCommentById(id: string): Promise<Comment>;
  getCommentsByNovelId(novelId: string): Promise<Comment[]>;
  createComment(comment: Omit<Comment, 'id' | 'createdAt' | 'updatedAt'>): Promise<Comment>;
  updateComment(id: string, comment: Partial<Comment>): Promise<Comment>;
  deleteComment(id: string): Promise<void>;
  getReportedComments(): Promise<Comment[]>;
  getCommentStats(): Promise<{
    totalComments: number;
    reportedComments: number;
    totalLikes: number;
  }>;
} 