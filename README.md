# 🚀 DevOps Auto-Scaling & Alerting Project

This project demonstrates a **real-world DevOps Monitoring Automation** setup that:
- Monitors EC2 instance metrics using Prometheus + Grafana
- Triggers alerts on high CPU usage via Alertmanager + email
- Automatically scales EC2 instances using **AWS CLI & Bash**

---

## 🧰 Tech Stack
- AWS EC2 + Auto Scaling Groups + Launch Templates
- Prometheus + Alertmanager
- Node Exporter
- Grafana Dashboard
- AWS CLI
- SNS Email Alerting
- Bash scripting

---

## 📸 Screenshots

### 🔥 High CPU Alert - Firing
![Firing](screenshots/alert_firing.jpeg)

### ✅ CPU Alert Resolved
![Resolved](screenshots/alert_resolved.jpeg)

### 📊 Node Exporter Metrics
![Metrics](screenshots/node_exporter_metrics.png)

### 📈 Prometheus CPU Data
![Prometheus](screenshots/prometheus_cpu_data.png)

### 📉 Grafana Monitoring Dashboard
![Grafana](screenshots/grafana_dashboard.png)

### 📬 Alertmanager UI
![Alertmanager](screenshots/alertmanager_ui.png)

### 📦 Auto-Scaled Instance (EC2)
![EC2](screenshots/ec2_scaled_instance.png)

---

## 🔧 Project Structure
```
.
├── README.md
├── alert.rules.yml
├── autoscale.sh
├── launch-template.json
├── prometheus.yml
├── alertmanager.yml
└── screenshots/
```

---

## 📄 Alert Rule (alert.rules.yml)
```yaml
groups:
  - name: High CPU Alerts
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance)(irate(node_cpu_seconds_total{mode="idle"}[1m])) * 100) > 75
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage > 75% for more than 1 minute."
```

---

## 🔁 Auto Scaling Script (autoscale.sh)
```bash
#!/bin/bash
aws autoscaling start-instance-refresh --auto-scaling-group-name devops-auto-asg
```

---

## 📤 Launch Template (launch-template.json)
```json
{
  "LaunchTemplateName": "devops-launch-template",
  "Version": "$Latest"
}
```

---

## ⚙️ Prometheus Config (prometheus.yml)
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']
```

---

## 📧 Alertmanager Config (alertmanager.yml)
```yaml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'your_email@gmail.com'
  smtp_auth_username: 'your_email@gmail.com'
  smtp_auth_password: 'your_app_password'

route:
  receiver: 'email-alert'

receivers:
  - name: 'email-alert'
    email_configs:
      - to: 'your_email@gmail.com'
```

---

## ✅ Output Summary

- Email Received on High CPU Spike ✅  
- New EC2 Instance Launched Automatically ✅  
- Email Received on Resolution ✅  

---

## ✨ Result

This project demonstrates **cost-efficient auto-scaling with live alert integration**, perfect for production-grade DevOps pipelines.

