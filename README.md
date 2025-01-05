# Railway Booking System

An online railway booking system designed to allow customers to search train schedules, make reservations, and manage their bookings. The system also provides tools for customer representatives to manage schedules and respond to customer inquiries, while administrators can generate reports and oversee operations. This project integrates a MySQL database with a JSP-based web application.

---

## Features

### **Customer Functionality**
- Search for train schedules by origin, destination, and date.
- Book one-way or round-trip train tickets with dynamic fare calculations, including discounts for children, seniors, and disabled passengers.
- View current and past reservations with detailed travel itineraries.
- Cancel reservations.
- Ask customer service questions via a forum-like interface.

### **Customer Representative Functionality**
- Manage train schedules (add, edit, and delete schedules).
- Respond to customer questions through the system.
- Generate reports:
  - Train schedules for specific stations (as origin or destination).
  - List of customers with reservations on a specific transit line and date.

### **Admin/Manager Functionality**
- Manage customer representative accounts (add, edit, and delete).
- Generate analytical reports:
  - Monthly sales reports.
  - Reservations by transit line or customer name.
  - Revenue by transit line or customer.
  - Top 5 most active transit lines and the customer with the highest revenue contribution.

---

## Technologies Used

- **Frontend**: HTML, JSP
- **Backend**: Java, JDBC
- **Database**: MySQL
- **Server**: Tomcat

---

## Setup

### **Prerequisites**
- MySQL Server and Workbench: **use "sql" folder to instantiate database locally**
- Apache Tomcat
- Java Development Kit (JDK)
- Eclipse IDE
