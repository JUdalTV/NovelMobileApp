import React, { useEffect, useState, useCallback, useMemo } from 'react';
import {
  Box,
  Container,
  Paper,
  Typography,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  IconButton,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Chip,
  Tabs,
  Tab,
} from '@mui/material';
import {
  Edit as EditIcon,
  Delete as DeleteIcon,
  Flag as FlagIcon,
} from '@mui/icons-material';
import { Comment } from '../../domain/entities/Comment';
import { CommentRepositoryImpl } from '../../data/repositories/CommentRepositoryImpl';

const CommentsManagement: React.FC = () => {
  const [comments, setComments] = useState<Comment[]>([]);
  const [openDialog, setOpenDialog] = useState(false);
  const [selectedComment, setSelectedComment] = useState<Comment | null>(null);
  const [formData, setFormData] = useState<{
    content: string;
    status: 'active' | 'hidden' | 'reported';
  }>({
    content: '',
    status: 'active',
  });
  const [activeTab, setActiveTab] = useState(0);

  const commentRepository = useMemo(() => new CommentRepositoryImpl(), []);

  const loadComments = useCallback(async () => {
    try {
      let data: Comment[];
      if (activeTab === 0) {
        data = await commentRepository.getComments();
      } else {
        data = await commentRepository.getReportedComments();
      }
      setComments(data);
    } catch (error) {
      console.error('Error loading comments:', error);
    }
  }, [activeTab, commentRepository]);

  useEffect(() => {
    loadComments();
  }, [loadComments]);

  const handleOpenDialog = (comment: Comment) => {
    setSelectedComment(comment);
    setFormData({
      content: comment.content,
      status: comment.status,
    });
    setOpenDialog(true);
  };

  const handleCloseDialog = () => {
    setOpenDialog(false);
    setSelectedComment(null);
  };

  const handleSubmit = async () => {
    if (!selectedComment) return;
    try {
      await commentRepository.updateComment(selectedComment.id, formData);
      handleCloseDialog();
      loadComments();
    } catch (error) {
      console.error('Error updating comment:', error);
    }
  };

  const handleDelete = async (id: string) => {
    if (window.confirm('Are you sure you want to delete this comment?')) {
      try {
        await commentRepository.deleteComment(id);
        loadComments();
      } catch (error) {
        console.error('Error deleting comment:', error);
      }
    }
  };

  const handleTabChange = (event: React.SyntheticEvent, newValue: number) => {
    setActiveTab(newValue);
  };

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 2 }}>
        <Typography variant="h4" component="h1">
          Comments Management
        </Typography>
      </Box>

      <Tabs value={activeTab} onChange={handleTabChange} sx={{ mb: 2 }}>
        <Tab label="All Comments" />
        <Tab
          label="Reported Comments"
          icon={<FlagIcon />}
          iconPosition="start"
        />
      </Tabs>

      <TableContainer component={Paper}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Content</TableCell>
              <TableCell>User</TableCell>
              <TableCell>Novel</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Likes</TableCell>
              <TableCell>Reported</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {comments.map((comment) => (
              <TableRow key={comment.id}>
                <TableCell>{comment.content}</TableCell>
                <TableCell>{comment.userId}</TableCell>
                <TableCell>{comment.novelId}</TableCell>
                <TableCell>
                  <Chip
                    label={comment.status}
                    color={
                      comment.status === 'active'
                        ? 'success'
                        : comment.status === 'hidden'
                        ? 'warning'
                        : 'error'
                    }
                    size="small"
                  />
                </TableCell>
                <TableCell>{comment.likes}</TableCell>
                <TableCell>
                  {comment.isReported ? (
                    <Chip
                      icon={<FlagIcon />}
                      label="Reported"
                      color="error"
                      size="small"
                    />
                  ) : (
                    '-'
                  )}
                </TableCell>
                <TableCell>
                  <IconButton onClick={() => handleOpenDialog(comment)}>
                    <EditIcon />
                  </IconButton>
                  <IconButton onClick={() => handleDelete(comment.id)}>
                    <DeleteIcon />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      <Dialog open={openDialog} onClose={handleCloseDialog}>
        <DialogTitle>Edit Comment</DialogTitle>
        <DialogContent>
          <TextField
            margin="dense"
            label="Content"
            fullWidth
            multiline
            rows={4}
            value={formData.content}
            onChange={(e) =>
              setFormData({ ...formData, content: e.target.value })
            }
          />
          <TextField
            margin="dense"
            label="Status"
            select
            fullWidth
            value={formData.status}
            onChange={(e) => setFormData({ ...formData, status: e.target.value as 'active' | 'hidden' | 'reported' })}
            SelectProps={{
              native: true,
            }}
          >
            <option value="active">Active</option>
            <option value="hidden">Hidden</option>
            <option value="reported">Reported</option>
          </TextField>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseDialog}>Cancel</Button>
          <Button onClick={handleSubmit} variant="contained">
            Update
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default CommentsManagement; 