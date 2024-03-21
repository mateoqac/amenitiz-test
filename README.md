# Cash Register Application

This application is a simple cash register that allows users to scan products and calculate the total price before and after discounts.
## Requirements

- Ruby 3.3.0

## Usage

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/mateoqac/amenitiz-test.git
   ```

2. Navigate to the directory
   ```bash
   cd amenitiz-test
   ```

3. Run the application
   ```bash
   ruby main.rb
   ```
4. Follow the prompts to scan products
   ```bash
   Available products:
   GR1: Green Tea - 3.11 €
   SR1: Strawberries - 5.00 €
   CF1: Coffee - 11.23 €
   ```
5. Enter 'DONE' when you have finished scanning products.
   ```bash
   Scan product (or 'done' to finish): DONE
   -------------------------------------------
   Scanned Items:
   1 x Green Tea - 3.11 €
   2 x Strawberries - 10.00 €
   -------------------------------------------
   Total price before discounts: 13.11 €
   Discount applied: 1.00 €
   Total price after discounts: 12.11 €
