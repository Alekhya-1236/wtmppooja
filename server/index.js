import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { createClient } from '@supabase/supabase-js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

app.get('/api/artworks', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('artworks')
      .select('*')
      .order('created_at', { ascending: false });

    if (error) throw error;

    res.json(data);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

app.post('/api/artworks', async (req, res) => {
  try {
    const { title, artist, price, image_url, description, email, user_id } = req.body;

    const { data, error } = await supabase
      .from('artworks')
      .insert([{
        title,
        artist,
        price,
        image_url,
        description,
        email,
        user_id
      }])
      .select()
      .single();

    if (error) throw error;

    res.status(201).json(data);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

app.put('/api/artworks/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { title, artist, price, image_url, description } = req.body;

    const { data, error } = await supabase
      .from('artworks')
      .update({
        title,
        artist,
        price,
        image_url,
        description,
        updated_at: new Date().toISOString()
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw error;

    res.json(data);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

app.delete('/api/artworks/:id', async (req, res) => {
  try {
    const { id } = req.params;

    const { error } = await supabase
      .from('artworks')
      .delete()
      .eq('id', id);

    if (error) throw error;

    res.json({ message: 'Artwork deleted successfully' });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
