const express = require('express');
const http = require('http');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');
const { Server } = require('socket.io');

// Load environment variables
dotenv.config();

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
  }
});

// Middleware
app.use(cors());
app.use(express.json());

// Root route
app.get('/', (req, res) => {
  res.send('Server is running!');
});

// Routes setup
const authRoutes = require('./routes/auth');
const messageRoutes = require('./routes/messages');

app.use('/api/auth', authRoutes);
app.use('/api/messages', messageRoutes);

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Could not connect to MongoDB:', err));

// WebSocket setup for Real-time Messaging
io.on('connection', (socket) => {
  console.log('A user connected:', socket.id);

  // Authenticate socket user
  socket.on('join', (userId) => {
    socket.join(userId);
    console.log(`User ${userId} joined their room.`);
  });

  // Handle incoming messages
  socket.on('sendMessage', async (data) => {
    console.log('Message received:', data);
    
    // data should contain { sender: 'id', receiver: 'id', text: 'content' }
    // Emit to receiver's room
    if (data.receiver) {
       io.to(data.receiver).emit('receiveMessage', data);
    }
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
