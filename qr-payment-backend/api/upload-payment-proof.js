const cors = require('cors');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Configure multer for file uploads
const storage = multer.memoryStorage(); // Use memory storage for Vercel

const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB limit
  },
  fileFilter: function (req, file, cb) {
    // Accept only image files
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed!'), false);
    }
  }
});

// In-memory store for payments (for demonstration purposes)
const payments = {}; // { transactionId: { timestamp: Date, status: 'pending' | 'completed' | 'failed' } }

// In-memory store for UTR to account mapping (for demonstration purposes)
const utrAccounts = {}; // { utr: 'account_name' }

// CORS configuration
const corsOptions = {
  origin: '*', // Configure this appropriately for production
  optionsSuccessStatus: 200
};

const corsMiddleware = cors(corsOptions);

// Export the Vercel serverless function
module.exports = async (req, res) => {
  // Apply CORS middleware
  corsMiddleware(req, res, async () => {
    try {
      // Handle preflight requests
      if (req.method === 'OPTIONS') {
        res.status(200).end();
        return;
      }
      
      // Only allow POST requests
      if (req.method !== 'POST') {
        res.status(405).json({ message: 'Method not allowed', success: false });
        return;
      }
      
      // Parse form data with multer
      upload.single('paymentProof')(req, res, async function (err) {
        if (err) {
          console.error('Multer error:', err);
          res.status(400).json({ message: err.message, success: false });
          return;
        }
        
        const { utr } = req.body;
        
        if (!utr) {
          res.status(400).json({ message: 'Missing UTR', success: false });
          return;
        }
        
        if (!req.file) {
          res.status(400).json({ message: 'No file uploaded', success: false });
          return;
        }
        
        // For Vercel, we can't store files locally, so we'll just process and acknowledge
        console.log('Payment proof received:');
        console.log('UTR:', utr);
        console.log('File size:', req.file.size);
        console.log('File type:', req.file.mimetype);
        
        // In a real implementation, you would:
        // 1. Upload the file to a storage service (like AWS S3, Cloudinary, etc.)
        // 2. Store the file URL and UTR in a database
        // 3. Send a message to your WhatsApp number with the UTR and file information
        
        // For now, we'll just return success
        res.status(200).json({ 
          message: 'Payment proof uploaded successfully!', 
          success: true
        });
      });
    } catch (error) {
      console.error('Error uploading payment proof:', error);
      res.status(500).json({ message: 'Error uploading payment proof', success: false });
    }
  });
};