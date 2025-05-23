import React, { useState } from 'react';
import { Novel } from '../../domain/entities/Novel';
import { uploadCoverImage } from '../../services/uploadService';

interface NovelFormProps {
  novel?: Novel;
  onSubmit: (novel: Partial<Novel>) => Promise<void>;
}

export const NovelForm: React.FC<NovelFormProps> = ({ novel, onSubmit }) => {
  const [title, setTitle] = useState(novel?.title || '');
  const [description, setDescription] = useState(novel?.description || '');
  const [author, setAuthor] = useState(novel?.author || '');
  const [categories, setCategories] = useState<string[]>(novel?.categories || []);
  const [tags, setTags] = useState<string[]>(novel?.tags || []);
  const [status, setStatus] = useState<Novel['status']>(novel?.status || 'ongoing');
  const [coverImage, setCoverImage] = useState<File | null>(null);
  const [previewUrl, setPreviewUrl] = useState(novel?.coverImage || '');
  const [isUploading, setIsUploading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsUploading(true);

    try {
      const novelData: Partial<Novel> = {
        title,
        description,
        author,
        categories,
        tags,
        status,
      };

      if (coverImage && novel?.id) {
        const coverImagePath = await uploadCoverImage(novel.id, coverImage);
        novelData.coverImage = coverImagePath;
      }

      await onSubmit(novelData);
    } finally {
      setIsUploading(false);
    }
  };

  const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setCoverImage(file);
      const reader = new FileReader();
      reader.onloadend = () => {
        setPreviewUrl(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleCategoriesChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    setCategories(value.split(',').map(cat => cat.trim()));
  };

  const handleTagsChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    setTags(value.split(',').map(tag => tag.trim()));
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label className="block text-sm font-medium text-gray-700">Title</label>
        <input
          type="text"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          required
        />
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Description</label>
        <textarea
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          rows={4}
          required
        />
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Author</label>
        <input
          type="text"
          value={author}
          onChange={(e) => setAuthor(e.target.value)}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          required
        />
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Categories (comma-separated)</label>
        <input
          type="text"
          value={categories.join(', ')}
          onChange={handleCategoriesChange}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          placeholder="e.g. Fantasy, Action, Adventure"
        />
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Tags (comma-separated)</label>
        <input
          type="text"
          value={tags.join(', ')}
          onChange={handleTagsChange}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
          placeholder="e.g. magic, sword, cultivation"
        />
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Status</label>
        <select
          value={status}
          onChange={(e) => setStatus(e.target.value as Novel['status'])}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
        >
          <option value="ongoing">Ongoing</option>
          <option value="completed">Completed</option>
          <option value="hiatus">Hiatus</option>
        </select>
      </div>

      <div>
        <label className="block text-sm font-medium text-gray-700">Cover Image</label>
        <input
          type="file"
          accept="image/*"
          onChange={handleImageChange}
          className="mt-1 block w-full"
        />
        {previewUrl && (
          <div className="mt-2">
            <img
              src={previewUrl}
              alt="Cover preview"
              className="h-32 w-32 object-cover rounded-lg"
            />
          </div>
        )}
      </div>

      <button
        type="submit"
        disabled={isUploading}
        className="inline-flex justify-center rounded-md border border-transparent bg-indigo-600 py-2 px-4 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 disabled:opacity-50"
      >
        {isUploading ? 'Saving...' : 'Save Novel'}
      </button>
    </form>
  );
}; 