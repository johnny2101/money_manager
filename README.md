# Money Manager

A Flutter mobile application for tracking personal expenses and managing spending categories with visual analytics.

## Features

- **Expense Tracking**: Add, edit, and delete payment records with detailed information
- **Category Management**: Create custom spending categories with color coding
- **Visual Analytics**: Interactive doughnut chart showing spending distribution by category
- **Payment Details**: Comprehensive payment information including title, amount, description, and date
- **Category Organization**: Organize expenses by custom categories for better tracking
- **Local Database**: All data stored locally using SQLite for offline functionality

## Screenshots

The app features a modern dark theme with:
- Interactive spending overview with doughnut chart
- Total spending display in the center of the chart
- Category-based expense organization
- Detailed payment history in card layout

## Technical Stack

- **Framework**: Flutter
- **Database**: SQLite (sqflite package)
- **Charts**: Syncfusion Flutter Charts
- **UI Components**: 
  - Staggered Grid View for payment cards
  - Color Picker for category customization
  - Material Design components

## Database Schema

### Payments Table
- `_id`: Primary key (auto-increment)
- `type`: Category type (links to categories)
- `import`: Amount spent (double)
- `title`: Payment title
- `description`: Payment description
- `createdTime`: Timestamp of creation

### Categories Table
- `_id`: Primary key (auto-increment)
- `category`: Category name
- `color`: Color value (integer)

## Project Structure

```
lib/
├── database/
│   ├── category.dart          # Category model and fields
│   ├── payment.dart           # Payment model and fields
│   └── payment_database.dart  # Database operations and SQLite setup
├── page/
│   ├── categories_page.dart       # Category list and management
│   ├── category_detail_page.dart  # Individual category details
│   ├── edit_category_page.dart    # Add/edit category form
│   ├── edit_payment_page.dart     # Add/edit payment form
│   ├── payment_detail_page.dart   # Individual payment details
│   └── payments_page.dart         # Main dashboard with chart and payments
├── widget/
│   ├── cageogry_form_widget.dart    # Category form components
│   ├── dropdown_wif.dart           # Dropdown widget helper
│   ├── payment_card_widget.dart    # Payment card display
│   └── payment_form_widget.dart    # Payment form components
└── main.dart                       # App entry point
```

## Key Features Breakdown

### Dashboard (PaymentsPage)
- Interactive doughnut chart showing spending by category
- Total spending amount displayed in chart center
- Grid layout of payment cards with staggered heights
- Quick access to add new payments and manage categories

### Payment Management
- Add new payments with category selection
- Edit existing payments
- Delete payments
- Rich payment details including amount, category, description, and date

### Category System
- Create custom spending categories
- Assign colors to categories for visual distinction
- Edit and delete categories
- Categories automatically populate in payment forms

### Data Visualization
- Real-time chart updates based on spending data
- Color-coded categories in chart
- Interactive chart elements with tap functionality
- Legend display for category identification

### Dependencies

Key packages used in this project:
- `sqflite`: SQLite database for local storage
- `syncfusion_flutter_charts`: Advanced charting capabilities
- `flutter_staggered_grid_view`: Flexible grid layouts
- `flutter_colorpicker`: Color selection for categories
- `intl`: Date formatting and internationalization

## Usage

1. **First Launch**: The app will create a local SQLite database automatically
2. **Add Categories**: Create spending categories (e.g., Food, Transportation, Entertainment)
3. **Record Payments**: Add your expenses with appropriate categories
4. **View Analytics**: Monitor your spending patterns through the interactive chart
5. **Manage Data**: Edit or delete payments and categories as needed

## Database Operations

The app includes comprehensive CRUD operations:
- **Create**: Add new payments and categories
- **Read**: Fetch individual items or lists of all items
- **Update**: Modify existing payments and categories
- **Delete**: Remove payments and categories

All operations are performed locally using SQLite, ensuring data privacy and offline functionality.

**Note**: This is a personal finance tracking application designed for individual use. All data is stored locally on your device.
