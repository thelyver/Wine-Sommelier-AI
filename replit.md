# AI Wine Sommelier

## Overview

This is an AI-powered wine sommelier application that provides personalized wine recommendations. Users can interact with an AI sommelier through natural language chat or browse wines using structured filters. The app features a Korean-language interface with wine data stored in PostgreSQL, and uses OpenAI for conversational AI capabilities.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **Framework**: React 18 with TypeScript
- **Routing**: Wouter (lightweight client-side routing)
- **State Management**: TanStack React Query for server state
- **UI Components**: shadcn/ui built on Radix UI primitives
- **Styling**: Tailwind CSS with CSS custom properties for theming
- **Build Tool**: Vite with HMR support

The frontend follows a component-based architecture with pages in `client/src/pages/` and reusable components in `client/src/components/`. The app supports light/dark theme switching.

### Backend Architecture
- **Framework**: Express.js with TypeScript
- **Database ORM**: Drizzle ORM with PostgreSQL
- **AI Integration**: OpenAI API (via Replit AI Integrations) for sommelier chat
- **Pattern**: RESTful API with streaming SSE for chat responses

API routes are registered in `server/routes.ts` with storage operations abstracted in `server/storage.ts`. The server supports both development (Vite middleware) and production (static file serving) modes.

### Data Model
Core tables defined in `shared/schema.ts`:
- **wines**: Main wine catalog with attributes (name, type, nation, tasting notes, price, etc.)
- **occasions**: Wine-occasion mappings for contextual recommendations  
- **conversations/messages**: Chat history for AI sommelier interactions
- **keywordLib**: Keyword mappings for filter-based search

### Key Design Decisions

**Hybrid Recommendation System**: Combines conversational AI with structured filtering to accommodate different user preferences - some prefer chatting naturally while others prefer clicking through filters.

**Streaming Chat Responses**: Uses Server-Sent Events for real-time AI response streaming, providing a more interactive user experience.

**Shared Schema**: Database schema lives in `shared/schema.ts` to ensure type consistency between frontend and backend using Drizzle-Zod integration.

**Wine Context Injection**: The AI sommelier receives the actual wine database as context to ensure recommendations are grounded in available inventory rather than hallucinated.

## External Dependencies

### Database
- **PostgreSQL**: Primary data store, connection via `DATABASE_URL` environment variable
- **Drizzle Kit**: Schema migrations with `npm run db:push`

### AI Services
- **OpenAI API**: Accessed via Replit AI Integrations for chat completions and sommelier functionality
- Environment variables: `AI_INTEGRATIONS_OPENAI_API_KEY`, `AI_INTEGRATIONS_OPENAI_BASE_URL`

### Third-Party Libraries
- **csv-parse**: Initial data seeding from CSV files in `attached_assets/`
- **connect-pg-simple**: PostgreSQL session storage (available but may not be actively used)

### Replit Integrations
The `server/replit_integrations/` directory contains pre-built utilities for:
- Audio/voice chat capabilities
- Image generation
- Batch processing with rate limiting
- Chat storage abstractions

These are scaffolded integration patterns that can be activated as needed.