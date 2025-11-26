/*
  # Create artworks table for Art Gallery

  1. New Tables
    - `artworks`
      - `id` (uuid, primary key) - Unique identifier for each artwork
      - `title` (text) - Title of the artwork
      - `artist` (text) - Name of the artist
      - `price` (numeric) - Price of the artwork
      - `image_url` (text) - URL to the artwork image
      - `description` (text) - Description of the artwork (optional)
      - `email` (text) - Contact email of the artist/uploader
      - `created_at` (timestamptz) - Timestamp when artwork was added
      - `updated_at` (timestamptz) - Timestamp when artwork was last updated

  2. Security
    - Enable RLS on `artworks` table
    - Add policy for anyone to view artworks (public gallery)
    - Add policy for authenticated users to insert artworks
    - Add policy for users to update their own artworks
    - Add policy for users to delete their own artworks

  3. Notes
    - All artworks are publicly viewable to support gallery browsing
    - Only authenticated users can upload artworks
    - Users can only modify or delete their own artworks
*/

CREATE TABLE IF NOT EXISTS artworks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  artist text NOT NULL,
  price numeric NOT NULL,
  image_url text NOT NULL,
  description text DEFAULT '',
  email text NOT NULL,
  user_id uuid REFERENCES auth.users(id),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE artworks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view artworks"
  ON artworks FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can insert artworks"
  ON artworks FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own artworks"
  ON artworks FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own artworks"
  ON artworks FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS artworks_created_at_idx ON artworks(created_at DESC);
CREATE INDEX IF NOT EXISTS artworks_email_idx ON artworks(email);