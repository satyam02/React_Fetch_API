# Stage 1: Build React application
FROM node:22 AS frontend-build

WORKDIR /app/frontend

COPY frontend/package*.json ./

RUN npm install

COPY frontend/ .

RUN npm run build


# Stage 2: Node.js production server
FROM node:22-alpine

WORKDIR /app

# Install backend dependencies
COPY backend/package*.json ./backend/

RUN cd backend && npm install --omit=dev

# Copy backend source
COPY backend/ ./backend/

# Copy React production build
COPY --from=frontend-build /app/frontend/dist ./frontend/dist

EXPOSE 8080

CMD ["node", "backend/server.js"]