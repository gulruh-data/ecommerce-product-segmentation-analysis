WITH product_stats AS (
    -- İlk adım: Ürün bazlı temel metrikleri hesaplıyoruz
    SELECT 
        k.product_id,
        k.product_name,
        SUM(s.qty) AS total_qty,
        SUM(s.qty * k.price) AS total_revenue
    FROM `course15.circle_sales` AS s
    JOIN `course15.circle_stock_kpi` AS k ON s.product_id = k.product_id
    GROUP BY 1, 2
)
SELECT 
    *,
    -- İkinci adım: Gelire göre segmentasyon yapıyoruz
    CASE 
        WHEN total_revenue > 100000 THEN 'A-Class (High Revenue)'
        WHEN total_revenue BETWEEN 50000 AND 100000 THEN 'B-Class (Medium)'
        ELSE 'C-Class (Low Revenue)'
    END AS revenue_segment,
    -- Üçüncü adım: Toplam içindeki payı (Percentage)
    ROUND(100 * total_revenue / SUM(total_revenue) OVER(), 2) AS share_in_total_revenue
FROM product_stats
ORDER BY total_revenue DESC;