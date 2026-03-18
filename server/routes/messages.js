const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const Message = require('../models/Message');
const auth = require('../middleware/auth');

// Send a message (also can be handled by socket.io, but REST API is good for saving if needed)
router.post('/', auth, async (req, res) => {
  try {
    const { receiver, content } = req.body;
    const message = new Message({
      sender: req.user._id,
      receiver,
      content
    });

    await message.save();
    res.status(201).json(message);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

// Get chat history between two users
router.get('/:userId', auth, async (req, res) => {
  try {
    const messages = await Message.find({
      $or: [
        { sender: req.user._id, receiver: req.params.userId },
        { sender: req.params.userId, receiver: req.user._id }
      ]
    }).sort({ timestamp: 1 });

    res.json(messages);
  } catch (err) {
    res.status(500).send(err.message);
  }
});

module.exports = router;
