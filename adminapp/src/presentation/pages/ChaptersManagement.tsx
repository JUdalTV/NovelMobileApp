import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
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
  IconButton,
  Typography,
} from '@mui/material';
import { Edit as EditIcon, Delete as DeleteIcon, Add as AddIcon } from '@mui/icons-material';
import { Chapter } from '../../domain/entities/Chapter';
import { chapterRepository } from '../../data/repositories/chapterRepository';

const ChaptersManagement: React.FC = () => {
  const { novelId } = useParams<{ novelId: string }>();
  const navigate = useNavigate();
  const [chapters, setChapters] = useState<Chapter[]>([]);
  const [selectedChapter, setSelectedChapter] = useState<Chapter | null>(null);
  const [openDialog, setOpenDialog] = useState(false);
  const [formData, setFormData] = useState({
    title: '',
    chapterNumber: '',
    content: '',
  });

  useEffect(() => {
    if (novelId) {
      loadChapters();
    }
  }, [novelId]);

  const loadChapters = async () => {
    try {
      const data = await chapterRepository.getChaptersByNovelId(novelId!);
      setChapters(data);
    } catch (error) {
      console.error('Error loading chapters:', error);
    }
  };

  const handleOpenDialog = (chapter?: Chapter) => {
    if (chapter) {
      setSelectedChapter(chapter);
      setFormData({
        title: chapter.title,
        chapterNumber: chapter.chapterNumber.toString(),
        content: chapter.content,
      });
    } else {
      setSelectedChapter(null);
      setFormData({
        title: '',
        chapterNumber: '',
        content: '',
      });
    }
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setSelectedChapter(null);
  };

  const handleSubmit = async () => {
    try {
      const chapterData = {
        ...formData,
        chapterNumber: parseInt(formData.chapterNumber),
        novelId,
      };

      if (selectedChapter) {
        await chapterRepository.updateChapter(selectedChapter.id, chapterData);
      } else {
        await chapterRepository.createChapter(chapterData);
      }
      handleCloseDialog();
      loadChapters();
    } catch (error) {
      console.error('Error saving chapter:', error);
    }
  };

  const handleDelete = async (id: string) => {
    if (window.confirm('Are you sure you want to delete this chapter?')) {
      try {
        await chapterRepository.deleteChapter(id);
        loadChapters();
      } catch (error) {
        console.error('Error deleting chapter:', error);
      }
    }
  };

  return (
    <Box p={3}>
      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h4">Chapters Management</Typography>
        <Button
          variant="contained"
          color="primary"
          startIcon={<AddIcon />}
          onClick={() => handleOpenDialog()}
        >
          Add New Chapter
        </Button>
      </Box>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Chapter Number</TableCell>
              <TableCell>Title</TableCell>
              <TableCell>Views</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {chapters.map((chapter) => (
              <TableRow key={chapter.id}>
                <TableCell>{chapter.chapterNumber}</TableCell>
                <TableCell>{chapter.title}</TableCell>
                <TableCell>{chapter.views}</TableCell>
                <TableCell>
                  <IconButton onClick={() => handleOpenDialog(chapter)}>
                    <EditIcon />
                  </IconButton>
                  <IconButton onClick={() => handleDelete(chapter.id)}>
                    <DeleteIcon />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <Dialog open={openDialog} onClose={handleCloseDialog} maxWidth="md" fullWidth>
        <DialogTitle>{selectedChapter ? 'Edit Chapter' : 'Add New Chapter'}</DialogTitle>
        <DialogContent>
          <Box display="flex" flexDirection="column" gap={2} mt={2}>
            <TextField
              name="chapterNumber"
              label="Chapter Number"
              type="number"
              value={formData.chapterNumber}
              onChange={(e) => setFormData({ ...formData, chapterNumber: e.target.value })}
              fullWidth
            />
            <TextField
              name="title"
              label="Title"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              fullWidth
            />
            <TextField
              name="content"
              label="Content"
              value={formData.content}
              onChange={(e) => setFormData({ ...formData, content: e.target.value })}
              multiline
              rows={10}
              fullWidth
            />
          </Box>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained" color="primary">
            {selectedChapter ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default ChaptersManagement; 