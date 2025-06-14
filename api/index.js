const express = require('express');
const prometheusMiddleware = require('express-prometheus-middleware');
const app = express();
const port = 3000;

app.use(prometheusMiddleware({
  metricsPath: '/metrics',
  collectDefaultMetrics: true,
  requestDurationBuckets: [0.1, 0.5, 1, 1.5],
}));

const sensors = [
  { id: 1, name: 'Température', value: 22.4, unit: '°C' },
  { id: 2, name: 'Humidité', value: 60, unit: '%' },
  { id: 3, name: 'CO2', value: 415, unit: 'ppm' }
];

app.get('/', (req, res) => {
  res.send('API de test déployée avec succès');
});

app.get('/sensors', (req, res) => {
  res.json(sensors);
});

app.get('/sensors/:id', (req, res) => {
  const sensorId = parseInt(req.params.id);
  const sensor = sensors.find(s => s.id === sensorId);

  if (sensor) {
    res.json(sensor);
  } else {
    res.status(404).json({ error: 'Capteur non trouvé' });
  }
});

app.listen(port, () => {
  console.log(`API en écoute sur http://localhost:${port}`);
});
