const uploadPaymentProof = require('./api/upload-payment-proof');

module.exports = (req, res) => {
  // Simple routing based on the path
  if (req.url === '/upload-payment-proof' && req.method === 'POST') {
    return uploadPaymentProof(req, res);
  }
  
  // Default response for other routes
  res.status(404).json({ message: 'Endpoint not found', success: false });
};