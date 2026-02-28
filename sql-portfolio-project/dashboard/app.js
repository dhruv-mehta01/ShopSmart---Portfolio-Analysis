/* ============================================================
   ShopSmart Analytics — Dashboard Charts
   Uses Chart.js with pre-computed data from data.js
   ============================================================ */

// Color palette
const COLORS = {
    indigo: '#6366f1',
    purple: '#8b5cf6',
    cyan: '#06b6d4',
    emerald: '#10b981',
    amber: '#f59e0b',
    red: '#ef4444',
    pink: '#ec4899',
    sky: '#0ea5e9',
    palette: ['#6366f1', '#06b6d4', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899', '#0ea5e9', '#14b8a6', '#f97316'],
    grid: 'rgba(148, 163, 184, 0.08)',
    gridText: '#64748b'
};

// Chart.js global defaults
Chart.defaults.color = COLORS.gridText;
Chart.defaults.font.family = "'Inter', sans-serif";
Chart.defaults.font.size = 12;
Chart.defaults.plugins.legend.labels.usePointStyle = true;
Chart.defaults.plugins.legend.labels.padding = 16;
Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(15, 23, 42, 0.95)';
Chart.defaults.plugins.tooltip.titleFont = { weight: '600' };
Chart.defaults.plugins.tooltip.padding = 12;
Chart.defaults.plugins.tooltip.cornerRadius = 10;
Chart.defaults.plugins.tooltip.borderColor = 'rgba(99, 102, 241, 0.2)';
Chart.defaults.plugins.tooltip.borderWidth = 1;

const D = DASHBOARD_DATA;

// --- Format helpers ---
function fmt(n) {
    if (n >= 100000) return '₹' + (n / 100000).toFixed(1) + 'L';
    if (n >= 1000) return '₹' + (n / 1000).toFixed(1) + 'K';
    return '₹' + n.toFixed(0);
}
function fmtPlain(n) {
    return n.toLocaleString('en-IN');
}

// --- KPIs ---
document.getElementById('kpi-total-revenue').textContent = fmt(D.kpis.total_revenue);
document.getElementById('kpi-total-orders').textContent = fmtPlain(D.kpis.total_orders);
document.getElementById('kpi-total-customers').textContent = fmtPlain(D.kpis.total_customers);
document.getElementById('kpi-avg-order').textContent = fmt(D.kpis.avg_order_value);

// --- 1. Monthly Revenue Trend (Line Chart) ---
new Chart(document.getElementById('revenueChart'), {
    type: 'line',
    data: {
        labels: D.monthlyRevenue.map(r => r.month),
        datasets: [{
            label: 'Revenue',
            data: D.monthlyRevenue.map(r => r.revenue),
            borderColor: COLORS.indigo,
            backgroundColor: createGradient('revenueChart', COLORS.indigo),
            fill: true,
            tension: 0.4,
            pointRadius: 3,
            pointHoverRadius: 6,
            pointBackgroundColor: COLORS.indigo,
            borderWidth: 2.5
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { display: false },
            tooltip: { callbacks: { label: ctx => fmt(ctx.parsed.y) } }
        },
        scales: {
            x: { grid: { color: COLORS.grid }, ticks: { maxRotation: 45, font: { size: 10 } } },
            y: { grid: { color: COLORS.grid }, ticks: { callback: v => fmt(v) } }
        }
    }
});

// --- 2. Category Revenue (Doughnut) ---
new Chart(document.getElementById('categoryChart'), {
    type: 'doughnut',
    data: {
        labels: D.categoryRevenue.map(r => r.category),
        datasets: [{
            data: D.categoryRevenue.map(r => r.revenue),
            backgroundColor: COLORS.palette.slice(0, D.categoryRevenue.length),
            borderWidth: 0,
            hoverOffset: 8
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '60%',
        plugins: {
            legend: { position: 'bottom', labels: { font: { size: 11 } } },
            tooltip: { callbacks: { label: ctx => `${ctx.label}: ${fmt(ctx.parsed)}` } }
        }
    }
});

// --- 3. Top Customers (Horizontal Bar) ---
new Chart(document.getElementById('customersChart'), {
    type: 'bar',
    data: {
        labels: D.topCustomers.map(r => r.name),
        datasets: [{
            label: 'Total Spent',
            data: D.topCustomers.map(r => r.total_spent),
            backgroundColor: COLORS.palette.slice(0, D.topCustomers.length).map(c => c + '99'),
            borderColor: COLORS.palette.slice(0, D.topCustomers.length),
            borderWidth: 1.5,
            borderRadius: 6
        }]
    },
    options: {
        indexAxis: 'y',
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { display: false },
            tooltip: { callbacks: { label: ctx => fmt(ctx.parsed.x) } }
        },
        scales: {
            x: { grid: { color: COLORS.grid }, ticks: { callback: v => fmt(v) } },
            y: { grid: { display: false }, ticks: { font: { size: 11 } } }
        }
    }
});

// --- 4. Regional Revenue (Polar Area) ---
new Chart(document.getElementById('regionChart'), {
    type: 'polarArea',
    data: {
        labels: D.regionRevenue.map(r => r.region),
        datasets: [{
            data: D.regionRevenue.map(r => r.revenue),
            backgroundColor: [COLORS.indigo + '88', COLORS.cyan + '88', COLORS.emerald + '88', COLORS.amber + '88'],
            borderColor: [COLORS.indigo, COLORS.cyan, COLORS.emerald, COLORS.amber],
            borderWidth: 2
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { position: 'bottom' },
            tooltip: { callbacks: { label: ctx => `${ctx.label}: ${fmt(ctx.parsed.r)}` } }
        },
        scales: {
            r: { grid: { color: COLORS.grid }, ticks: { display: false } }
        }
    }
});

// --- 5. Order Status (Doughnut) ---
new Chart(document.getElementById('statusChart'), {
    type: 'doughnut',
    data: {
        labels: D.orderStatus.map(r => r.status),
        datasets: [{
            data: D.orderStatus.map(r => r.count),
            backgroundColor: [COLORS.emerald + 'cc', COLORS.amber + 'cc', COLORS.red + 'cc', COLORS.purple + 'cc'],
            borderWidth: 0,
            hoverOffset: 6
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '55%',
        plugins: { legend: { position: 'bottom', labels: { font: { size: 11 } } } }
    }
});

// --- 6. Payment Methods (Bar) ---
new Chart(document.getElementById('paymentChart'), {
    type: 'bar',
    data: {
        labels: D.paymentMethods.map(r => r.payment_method),
        datasets: [{
            label: 'Count',
            data: D.paymentMethods.map(r => r.count),
            backgroundColor: COLORS.palette.slice(0, D.paymentMethods.length).map(c => c + '99'),
            borderColor: COLORS.palette.slice(0, D.paymentMethods.length),
            borderWidth: 1.5,
            borderRadius: 6
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false } },
        scales: {
            x: { grid: { display: false }, ticks: { font: { size: 10 } } },
            y: { grid: { color: COLORS.grid } }
        }
    }
});

// --- 7. Customer Segments (Pie) ---
new Chart(document.getElementById('segmentChart'), {
    type: 'pie',
    data: {
        labels: D.customerSegments.map(r => r.segment),
        datasets: [{
            data: D.customerSegments.map(r => r.count),
            backgroundColor: [COLORS.indigo + 'cc', COLORS.cyan + 'cc', COLORS.amber + 'cc', COLORS.emerald + 'cc'],
            borderWidth: 0,
            hoverOffset: 6
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: 'bottom', labels: { font: { size: 11 } } } }
    }
});

// --- 8. Top Products (Horizontal Bar) ---
new Chart(document.getElementById('productsChart'), {
    type: 'bar',
    data: {
        labels: D.topProducts.map(r => r.name),
        datasets: [
            {
                label: 'Revenue',
                data: D.topProducts.map(r => r.revenue),
                backgroundColor: COLORS.indigo + '88',
                borderColor: COLORS.indigo,
                borderWidth: 1.5,
                borderRadius: 6
            },
            {
                label: 'Qty Sold',
                data: D.topProducts.map(r => r.qty_sold),
                backgroundColor: COLORS.cyan + '88',
                borderColor: COLORS.cyan,
                borderWidth: 1.5,
                borderRadius: 6,
                yAxisID: 'y1'
            }
        ]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { position: 'top' },
            tooltip: {
                callbacks: {
                    label: ctx => {
                        if (ctx.datasetIndex === 0) return 'Revenue: ' + fmt(ctx.parsed.y);
                        return 'Qty: ' + ctx.parsed.y;
                    }
                }
            }
        },
        scales: {
            x: { grid: { display: false }, ticks: { maxRotation: 45, font: { size: 10 } } },
            y: { grid: { color: COLORS.grid }, position: 'left', ticks: { callback: v => fmt(v) }, title: { display: true, text: 'Revenue', color: COLORS.gridText } },
            y1: { grid: { display: false }, position: 'right', title: { display: true, text: 'Quantity', color: COLORS.gridText } }
        }
    }
});

// --- Gradient helper ---
function createGradient(canvasId, color) {
    const canvas = document.getElementById(canvasId);
    const ctx = canvas.getContext('2d');
    const gradient = ctx.createLinearGradient(0, 0, 0, 300);
    gradient.addColorStop(0, color + '40');
    gradient.addColorStop(1, color + '05');
    return gradient;
}
