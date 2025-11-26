# Art Gallery Server

This server folder has been integrated from the ARTGALLERY project and adapted to use Supabase instead of MongoDB.

## Setup

1. Install dependencies:
```bash
cd server
npm install
```

2. Create a `.env` file in the server folder with your Supabase credentials:
```
PORT=5000
SUPABASE_URL=your_supabase_url
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
```

3. The database table `artworks` has already been created with the following schema:
   - id (uuid)
   - title (text)
   - artist (text)
   - price (numeric)
   - image_url (text)
   - description (text)
   - email (text)
   - user_id (uuid, references auth.users)
   - created_at (timestamptz)
   - updated_at (timestamptz)

## Running the Server

Development mode (with auto-reload):
```bash
npm run dev
```

Production mode:
```bash
npm start
```

## API Endpoints

- `GET /api/artworks` - Get all artworks (sorted by newest first)
- `POST /api/artworks` - Upload a new artwork
- `PUT /api/artworks/:id` - Update an existing artwork
- `DELETE /api/artworks/:id` - Delete an artwork

## Changes from Original

The original server used MongoDB. This version has been adapted to use Supabase with:
- Supabase client instead of Mongoose
- Row Level Security (RLS) policies for secure data access
- UUID-based IDs instead of MongoDB ObjectIDs
- Additional UPDATE and DELETE endpoints
- User authentication support via user_id field
