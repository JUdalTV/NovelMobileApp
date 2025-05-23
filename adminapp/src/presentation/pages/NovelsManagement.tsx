import React, { useState, useEffect } from 'react';
import {
  Box,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Paper,
  Chip,
  IconButton,
  Typography,
} from '@mui/material';
import { Edit as EditIcon, Delete as DeleteIcon, Book as BookIcon } from '@mui/icons-material';
import { Novel, NovelStatus, NovelFormData } from '../../domain/entities/Novel';
import { novelRepository } from '../../data/repositories/novelRepository';
import { uploadCoverImage } from '../../services/uploadService';
import { useNavigate } from 'react-router-dom';

const NovelsManagement: React.FC = () => {
  const [novels, setNovels] = useState<Novel[]>([]);
  const [selectedNovel, setSelectedNovel] = useState<Novel | null>(null);
  const [openDialog, setOpenDialog] = useState(false);
  const [formData, setFormData] = useState<NovelFormData>({
    title: '',
    description: '',
    author: '',
    coverImage: '',
    categories: [],
    tags: [],
    status: 'ongoing',
    totalChapters: 0,
    views: 0,
    rating: 0,
    totalRatings: 0,
  });
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    loadNovels();
  }, []);

  const loadNovels = async () => {
    try {
      const data = await novelRepository.getAllNovels();
      setNovels(data);
    } catch (error) {
      console.error('Error loading novels:', error);
    }
  };

  const handleOpenDialog = (novel?: Novel) => {
    if (novel) {
      setSelectedNovel(novel);
      setFormData({
        title: novel.title,
        description: novel.description,
        author: novel.author,
        coverImage: novel.coverImage,
        categories: novel.categories,
        tags: novel.tags,
        status: novel.status,
        totalChapters: novel.totalChapters,
        views: novel.views,
        rating: novel.rating,
        totalRatings: novel.totalRatings,
      });
    } else {
      setSelectedNovel(null);
      setFormData({
        title: '',
        description: '',
        author: '',
        coverImage: '',
        categories: [],
        tags: [],
        status: 'ongoing',
        totalChapters: 0,
        views: 0,
        rating: 0,
        totalRatings: 0,
      });
    }
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setSelectedNovel(null);
    setSelectedFile(null);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev: NovelFormData) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setSelectedFile(e.target.files[0]);
    }
  };

  const handleSubmit = async () => {
    try {
      if (selectedNovel) {
        if (selectedFile) {
          const coverImageUrl = await uploadCoverImage(selectedNovel.id, selectedFile);
          await novelRepository.updateNovel(selectedNovel.id, { ...formData, coverImage: coverImageUrl });
        } else {
        await novelRepository.updateNovel(selectedNovel.id, formData);
        }
      } else {
        if (selectedFile) {
          const novel = await novelRepository.createNovel(formData);
          const coverImageUrl = await uploadCoverImage(novel.id, selectedFile);
          await novelRepository.updateNovel(novel.id, { ...formData, coverImage: coverImageUrl });
      } else {
        await novelRepository.createNovel(formData);
        }
      }
      handleCloseDialog();
      loadNovels();
    } catch (error) {
      console.error('Error saving novel:', error);
    }
  };

  const handleDelete = async (id: string) => {
    if (window.confirm('Are you sure you want to delete this novel?')) {
      try {
        await novelRepository.deleteNovel(id);
        loadNovels();
      } catch (error) {
        console.error('Error deleting novel:', error);
      }
    }
  };

  return (
    <Box p={3}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Novels Management</Typography>
        <Button variant="contained" color="primary" onClick={() => handleOpenDialog()}>
          Add New Novel
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Title</TableCell>
              <TableCell>Author</TableCell>
              <TableCell>Categories</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Chapters</TableCell>
              <TableCell>Views</TableCell>
              <TableCell>Rating</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {novels.map((novel) => (
              <TableRow key={novel.id}>
                <TableCell>{novel.title}</TableCell>
                <TableCell>{novel.author}</TableCell>
                <TableCell>
                  {novel.categories.map((category) => (
                    <Chip key={category} label={category} size="small" style={{ margin: '2px' }} />
                  ))}
                </TableCell>
                <TableCell>
                  <Chip
                    label={novel.status}
                    color={
                      novel.status === 'ongoing'
                        ? 'primary'
                        : novel.status === 'completed'
                        ? 'success'
                        : 'warning'
                    }
                    size="small"
                  />
                </TableCell>
                <TableCell>{novel.totalChapters}</TableCell>
                <TableCell>{novel.views}</TableCell>
                <TableCell>{novel.rating.toFixed(1)}</TableCell>
                <TableCell>
                  <IconButton onClick={() => handleOpenDialog(novel)}>
                    <EditIcon />
                  </IconButton>
                  <IconButton onClick={() => handleDelete(novel.id)}>
                    <DeleteIcon />
                  </IconButton>
                  <Button
                    variant="outlined"
                    size="small"
                    onClick={() => navigate(`/novels/${novel.id}/chapters`)}
                    startIcon={<BookIcon />}
                  >
                    Manage Chapters
                  </Button>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="md" fullWidth>
        <DialogTitle>{selectedNovel ? 'Edit Novel' : 'Add New Novel'}</DialogTitle>
        <DialogContent>
          <Box display="flex" flexDirection="column" gap={2} mt={2}>
          <TextField
              name="title"
            label="Title"
              value={formData.title}
              onChange={handleInputChange}
              fullWidth
            />
            <TextField
              name="description"
              label="Description"
              value={formData.description}
              onChange={handleInputChange}
              multiline
              rows={4}
            fullWidth
          />
          <TextField
              name="author"
            label="Author"
              value={formData.author}
              onChange={handleInputChange}
              fullWidth
            />
            <TextField
              name="categories"
              label="Categories (comma-separated)"
              value={formData.categories.join(', ')}
              onChange={(e) => {
                const categories = e.target.value.split(',').map((cat) => cat.trim());
                setFormData((prev: NovelFormData) => ({ ...prev, categories }));
              }}
            fullWidth
          />
          <TextField
              name="tags"
              label="Tags (comma-separated)"
              value={formData.tags.join(', ')}
              onChange={(e) => {
                const tags = e.target.value.split(',').map((tag) => tag.trim());
                setFormData((prev: NovelFormData) => ({ ...prev, tags }));
              }}
            fullWidth
          />
          <TextField
              name="status"
            label="Status"
            select
            value={formData.status}
              onChange={(e) => {
                setFormData((prev: NovelFormData) => ({ ...prev, status: e.target.value as NovelStatus }));
              }}
              fullWidth
              SelectProps={{ native: true }}
          >
              <option value="ongoing">Ongoing</option>
              <option value="completed">Completed</option>
              <option value="hiatus">Hiatus</option>
          </TextField>
            <input
              type="file"
              accept="image/*"
              onChange={handleFileChange}
              style={{ marginTop: '16px' }}
          />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained" color="primary">
            {selectedNovel ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default NovelsManagement; 