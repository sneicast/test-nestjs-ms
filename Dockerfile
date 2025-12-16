# ==========================================
# Stage 1: Build
# ==========================================
FROM node:22-alpine AS builder

WORKDIR /app

# Copiar archivos de dependencias primero para aprovechar el cache de Docker
COPY package*.json ./

# Instalar todas las dependencias (incluyendo devDependencies para el build)
RUN npm ci

# Copiar el código fuente
COPY . .

# Compilar la aplicación
RUN npm run build

# ==========================================
# Stage 2: Production
# ==========================================
FROM node:22-alpine AS production

# Crear usuario no-root por seguridad
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nestjs -u 1001

WORKDIR /app

# Configurar variables de entorno para producción
ENV NODE_ENV=production

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar solo dependencias de producción
RUN npm ci --only=production && \
    npm cache clean --force

# Copiar el build desde la etapa anterior
COPY --from=builder /app/dist ./dist

# Cambiar al usuario no-root
USER nestjs

# Puerto que Cloud Run inyectará via variable de entorno PORT
EXPOSE 8080

# Comando de inicio
CMD ["node", "dist/main"]

