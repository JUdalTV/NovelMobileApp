import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';
import Layout from './presentation/components/Layout';
import Dashboard from './presentation/pages/Dashboard';
import UsersManagement from './presentation/pages/UsersManagement';
import NovelsManagement from './presentation/pages/NovelsManagement';
import CommentsManagement from './presentation/pages/CommentsManagement';
import Settings from './presentation/pages/Settings';
import ChaptersManagement from './presentation/pages/ChaptersManagement';

const theme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
  },
});

const App: React.FC = () => {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <Layout>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/users" element={<UsersManagement />} />
            <Route path="/novels" element={<NovelsManagement />} />
            <Route path="/novels/:novelId/chapters" element={<ChaptersManagement />} />
            <Route path="/comments" element={<CommentsManagement />} />
            <Route path="/settings" element={<Settings />} />
          </Routes>
        </Layout>
      </Router>
    </ThemeProvider>
  );
};

export default App; 