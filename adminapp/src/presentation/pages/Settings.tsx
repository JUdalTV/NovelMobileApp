import React, { useState } from 'react';
import {
  Box,
  Container,
  Paper,
  Typography,
  TextField,
  Button,
  Grid,
  Switch,
  FormControlLabel,
  Divider,
  Alert,
} from '@mui/material';
import { Save as SaveIcon } from '@mui/icons-material';

const Settings: React.FC = () => {
  const [settings, setSettings] = useState({
    siteName: 'Novel Platform',
    siteDescription: 'A platform for reading and sharing novels',
    adminEmail: 'admin@example.com',
    maxUploadSize: '10',
    allowedFileTypes: 'jpg,jpeg,png,pdf',
    enableUserRegistration: true,
    requireEmailVerification: true,
    enableComments: true,
    enableRatings: true,
    maintenanceMode: false,
  });

  const [message, setMessage] = useState<{
    type: 'success' | 'error';
    text: string;
  } | null>(null);

  const handleChange = (field: string) => (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const value =
      event.target.type === 'checkbox'
        ? event.target.checked
        : event.target.value;
    setSettings({ ...settings, [field]: value });
  };

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    try {
      // TODO: Implement settings update API call
      setMessage({
        type: 'success',
        text: 'Settings updated successfully',
      });
    } catch (error) {
      setMessage({
        type: 'error',
        text: 'Failed to update settings',
      });
    }
  };

  return (
    <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
      <Typography variant="h4" component="h1" gutterBottom>
        Settings
      </Typography>

      {message && (
        <Alert severity={message.type} sx={{ mb: 2 }}>
          {message.text}
        </Alert>
      )}

      <Paper sx={{ p: 3 }}>
        <form onSubmit={handleSubmit}>
          <Grid container spacing={3}>
            <Grid item xs={12}>
              <Typography variant="h6" gutterBottom>
                General Settings
              </Typography>
            </Grid>

            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Site Name"
                value={settings.siteName}
                onChange={handleChange('siteName')}
              />
            </Grid>

            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Admin Email"
                type="email"
                value={settings.adminEmail}
                onChange={handleChange('adminEmail')}
              />
            </Grid>

            <Grid item xs={12}>
              <TextField
                fullWidth
                label="Site Description"
                multiline
                rows={2}
                value={settings.siteDescription}
                onChange={handleChange('siteDescription')}
              />
            </Grid>

            <Grid item xs={12}>
              <Divider sx={{ my: 2 }} />
              <Typography variant="h6" gutterBottom>
                Upload Settings
              </Typography>
            </Grid>

            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Max Upload Size (MB)"
                type="number"
                value={settings.maxUploadSize}
                onChange={handleChange('maxUploadSize')}
              />
            </Grid>

            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Allowed File Types"
                value={settings.allowedFileTypes}
                onChange={handleChange('allowedFileTypes')}
                helperText="Comma-separated list of file extensions"
              />
            </Grid>

            <Grid item xs={12}>
              <Divider sx={{ my: 2 }} />
              <Typography variant="h6" gutterBottom>
                Feature Settings
              </Typography>
            </Grid>

            <Grid item xs={12} md={6}>
              <FormControlLabel
                control={
                  <Switch
                    checked={settings.enableUserRegistration}
                    onChange={handleChange('enableUserRegistration')}
                  />
                }
                label="Enable User Registration"
              />
            </Grid>

            <Grid item xs={12} md={6}>
              <FormControlLabel
                control={
                  <Switch
                    checked={settings.requireEmailVerification}
                    onChange={handleChange('requireEmailVerification')}
                  />
                }
                label="Require Email Verification"
              />
            </Grid>

            <Grid item xs={12} md={6}>
              <FormControlLabel
                control={
                  <Switch
                    checked={settings.enableComments}
                    onChange={handleChange('enableComments')}
                  />
                }
                label="Enable Comments"
              />
            </Grid>

            <Grid item xs={12} md={6}>
              <FormControlLabel
                control={
                  <Switch
                    checked={settings.enableRatings}
                    onChange={handleChange('enableRatings')}
                  />
                }
                label="Enable Ratings"
              />
            </Grid>

            <Grid item xs={12}>
              <Divider sx={{ my: 2 }} />
              <Typography variant="h6" gutterBottom>
                System Settings
              </Typography>
            </Grid>

            <Grid item xs={12}>
              <FormControlLabel
                control={
                  <Switch
                    checked={settings.maintenanceMode}
                    onChange={handleChange('maintenanceMode')}
                  />
                }
                label="Maintenance Mode"
              />
            </Grid>

            <Grid item xs={12}>
              <Box sx={{ display: 'flex', justifyContent: 'flex-end', mt: 2 }}>
                <Button
                  type="submit"
                  variant="contained"
                  startIcon={<SaveIcon />}
                  size="large"
                >
                  Save Settings
                </Button>
              </Box>
            </Grid>
          </Grid>
        </form>
      </Paper>
    </Container>
  );
};

export default Settings; 