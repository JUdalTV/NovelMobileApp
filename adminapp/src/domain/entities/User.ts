export interface User {
  id: string;
  username: string;
  email: string;
  role: 'admin' | 'user' | 'moderator';
  isVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
} 