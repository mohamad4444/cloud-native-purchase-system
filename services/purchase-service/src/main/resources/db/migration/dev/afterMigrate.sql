TRUNCATE TABLE purchases RESTART IDENTITY CASCADE;
INSERT INTO purchases (
  lager_item_id,
  product_name,
  quantity,
  timestamp,
  status,
  user_id
) VALUES
  (1001, 'Product A', 5, NOW() - INTERVAL '10 days', 'PENDING', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1002, 'Product B', 3, NOW() - INTERVAL '9 days', 'CONFIRMED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1003, 'Product C', 1, NOW() - INTERVAL '8 days', 'REJECTED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1004, 'Product D', 10, NOW() - INTERVAL '7 days', 'PENDING', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1005, 'Product E', 7, NOW() - INTERVAL '6 days', 'CONFIRMED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1006, 'Product F', 2, NOW() - INTERVAL '5 days', 'REJECTED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1007, 'Product G', 4, NOW() - INTERVAL '4 days', 'PENDING', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1008, 'Product H', 6, NOW() - INTERVAL '3 days', 'CONFIRMED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1009, 'Product I', 9, NOW() - INTERVAL '2 days', 'REJECTED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1010, 'Product J', 8, NOW() - INTERVAL '1 day', 'PENDING', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),

  (1011, 'Product K', 11, NOW() - INTERVAL '20 hours', 'CONFIRMED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1012, 'Product L', 12, NOW() - INTERVAL '18 hours', 'REJECTED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1013, 'Product M', 13, NOW() - INTERVAL '16 hours', 'PENDING', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1014, 'Product N', 14, NOW() - INTERVAL '14 hours', 'CONFIRMED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1015, 'Product O', 15, NOW() - INTERVAL '12 hours', 'REJECTED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1016, 'Product P', 16, NOW() - INTERVAL '10 hours', 'PENDING', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1017, 'Product Q', 17, NOW() - INTERVAL '8 hours', 'CONFIRMED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1018, 'Product R', 18, NOW() - INTERVAL '6 hours', 'REJECTED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1019, 'Product S', 19, NOW() - INTERVAL '4 hours', 'PENDING', '9b84fcdf-6f83-4402-b631-6a97b0de6f86'),
  (1020, 'Product T', 20, NOW() - INTERVAL '2 hours', 'CONFIRMED', '9b84fcdf-6f83-4402-b631-6a97b0de6f86');
