require 'rails_helper'

RSpec.describe 'Merchant Invoices Show Page' do
  describe 'As a merchant' do
    describe 'When I visit my merchant invoices show page' do
      it 'Then I see information related to that invoice' do
        @merchant = Merchant.first
        invoice_1 = @merchant.invoices.first
        invoice_2 = @merchant.invoices.last

        visit merchant_invoice_path(@merchant, invoice_1)

          expect(page).to have_content("Invoice ID: 1")
          expect(page).to have_content("Invoice Status: cancelled")
          expect(page).to have_content("Invoice Date: Sunday, March 25, 2012")
          expect(page).to have_content("Invoice Customer Name: Joey Ondricka")
          expect(page).to_not have_content("Invoice ID: 5")
      end

      it 'I see all of my items on the invoice including the name' do
        @merchant = Merchant.first
        invoice_1 = @merchant.invoices.first

        visit merchant_invoice_path(@merchant, invoice_1)

        within "div#1" do
          expect(page).to have_content("Item Name: Item Qui Esse")
          expect(page).to have_content("Item Quantity: 5")
          expect(page).to have_content("Item Unit Price: $136.35")

          expect(page).to_not have_content("Item Name: Item Expedita Aliquam")
          expect(page).to_not have_content("Item Name: Provident At")
        end
      end

      it 'I see the total revenue that will be generated from all of my items on the invoice' do
        @merchant = Merchant.first
        invoice_1 = @merchant.invoices.first
        invoice_2 = @merchant.invoices.last

        visit merchant_invoice_path(@merchant, invoice_1)
          expect(page).to have_content("Total Revenue: $21067.77")
      end

      it 'I see that each invoice item status is a select field and I see that the invoice items current status is selected' do
        @merchant = Merchant.first
        invoice_1 = @merchant.invoices.first
        invoice_2 = @merchant.invoices.last

        visit merchant_invoice_path(@merchant, invoice_1)

        within "div#1" do
          within "#status_#{invoice_1.invoice_items.first.id}" do
            expect(page).to have_select('status'), 'packaged'
          end
        end
      end

      describe 'When I click this select field' do
        it 'I can select a new status for the Item' do
          @merchant = Merchant.first
          invoice_1 = @merchant.invoices.first
          invoice_2 = @merchant.invoices.last

          visit merchant_invoice_path(@merchant, invoice_1)

          within "div#1" do
            within "#status_#{invoice_1.invoice_items.first.id}" do
              select :shipped, from: 'status'

              expect(page).to have_select('status'), 'shipped'
            end
          end
        end

        it 'next to the select field I see a button to "Update Item Status"' do
          @merchant = Merchant.first
          invoice_1 = @merchant.invoices.first
          invoice_2 = @merchant.invoices.last

          visit merchant_invoice_path(@merchant, invoice_1)

          within "div#1" do
            within "#status_#{invoice_1.invoice_items.first.id}" do
              expect(page).to have_button('Update Item Status')
            end
          end
        end

        describe 'When I click this button' do
          it 'I am taken back to the merchant invoice show page' do
            @merchant = Merchant.first
            invoice_1 = @merchant.invoices.first
            invoice_2 = @merchant.invoices.last

            visit merchant_invoice_path(@merchant, invoice_1)

            within "div#1" do
              within "#status_#{invoice_1.invoice_items.first.id}" do
                select :shipped, from: 'status'
                click_button 'Update Item Status'
                expect(current_path).to eq(merchant_invoice_path(@merchant, invoice_1))
              end
            end
          end

          it 'I see that my Items status has now been updated' do
            @merchant = Merchant.first
            invoice_1 = @merchant.invoices.first
            invoice_2 = @merchant.invoices.last

            visit merchant_invoice_path(@merchant, invoice_1)

            within "div#1" do
              within "#status_#{invoice_1.invoice_items.first.id}" do
                select :shipped, from: 'status'
                click_button 'Update Item Status'
                expect(page).to have_select('status'), 'shipped'
              end
            end
          end
        end
      end
    end
    
    describe 'Merchant Invoice Show Page: Total Revenue and Discounted Revenue' do
      describe 'When I visit my merchant invoice show page, ' do
        it 'I see the total revenue for my merchant from this invoice (not including discounts)' do
          @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")

          @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)

          @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe")

          @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
          @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)

          @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)

          @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
          @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)
          
          visit merchant_invoice_path(@merchant1, @invoice1)
          
          expect(page).to have_content("Total Revenue: $214.85")
        end

        it 'I see the total discounted revenue for my merchant from this invoice which when the merchant does NOT have any current discounts' do
          @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
          
          @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe")

          @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
          @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)

          @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)

          @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
          @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)
          
          visit merchant_invoice_path(@merchant1, @invoice1)

          expect(page).to have_content("Total Discounted Revenue: $214.85")
        end
        
        it 'I see the total discounted revenue for my merchant from this invoice which when the merchant has ONE discount' do
          @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
          
          @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)

          @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe")

          @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
          @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
          @item3 = Item.create!(id: 47, name:"Mini basket", description:"pink and small", unit_price: 999, merchant_id: @merchant1.id)

          @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)

          @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
          @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)
          @invoice_item3 = InvoiceItem.create!(id: 47, item_id: @item3.id, invoice_id: @invoice1.id, quantity:10 , unit_price:999 , status: 1)
          
          visit merchant_invoice_path(@merchant1, @invoice1)

          expect(page).to have_content("Total Discounted Revenue: $254.80")
        end

        it 'I see the total discounted revenue for my merchant from this invoice which when the merchant has MULTIPLE discounts' do
          @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
          
          @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)
          @discount_b = BulkDiscount.create!(description: "B", quantity_break: 15, discount: 30, merchant_id: @merchant1.id)

          @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe")

          @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
          @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
          @item3 = Item.create!(id: 47, name:"Mini basket", description:"pink and small", unit_price: 999, merchant_id: @merchant1.id)

          @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)

          @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
          @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)
          @invoice_item3 = InvoiceItem.create!(id: 47, item_id: @item3.id, invoice_id: @invoice1.id, quantity:15 , unit_price:999 , status: 1)
          
          visit merchant_invoice_path(@merchant1, @invoice1)

          expect(page).to have_content("Total Discounted Revenue: $284.77")
        end

        it 'I see a link to the show page for the bulk discount that was applied to each item' do
          @merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
          
          @discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 25, merchant_id: @merchant1.id)
          @discount_b = BulkDiscount.create!(description: "B", quantity_break: 15, discount: 30, merchant_id: @merchant1.id)

          @customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe")

          @item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: @merchant1.id)
          @item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: @merchant1.id)
          @item3 = Item.create!(id: 47, name:"Mini basket", description:"pink and small", unit_price: 999, merchant_id: @merchant1.id)

          @invoice1 = Invoice.create!(id: 45, customer_id: @customer1.id, status: 1)

          @invoice_item1 = InvoiceItem.create!(id: 45, item_id: @item1.id, invoice_id: @invoice1.id, quantity:5, unit_price:1499 , status: 0)
          @invoice_item2 = InvoiceItem.create!(id: 46, item_id: @item2.id, invoice_id: @invoice1.id, quantity:10 , unit_price:1399 , status: 1)
          @invoice_item3 = InvoiceItem.create!(id: 47, item_id: @item3.id, invoice_id: @invoice1.id, quantity:15 , unit_price:999 , status: 1)

          visit merchant_invoice_path(@merchant1, @invoice1)
          
          within "div##{@item1.id}" do
            expect(page).to_not have_link("Bulk Discount Applied")
          end
          
          within "div##{@item2.id}" do
            expect(page).to have_link("Bulk Discount Applied")
          end

          within "div##{@item3.id}" do
            expect(page).to have_link("Bulk Discount Applied")
            click_link("Bulk Discount Applied")
            expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount_b))
          end
        end

        it "Should return the total discounted invoice revenue for ALL items when a merchant has a multiple applicable discounts" do
          #exapmle #5
          merchant1 = Merchant.create!(id: 45, name:"Bob's Baskets")
          merchant2 = Merchant.create!(id: 46, name:"Sue's Shoes")
          discount_a = BulkDiscount.create!(description: "A", quantity_break: 10, discount: 20, merchant_id: merchant1.id)
          discount_b = BulkDiscount.create!(description: "B", quantity_break: 15, discount: 30, merchant_id: merchant1.id)
          customer1 = Customer.create!(id: 45, first_name:"John", last_name:"Doe") 
          item1 = Item.create!(id: 45, name:"Big basket", description:"Green and big", unit_price: 1499, merchant_id: merchant1.id)
          item2 = Item.create!(id: 46, name:"Medium basket", description:"Blue and medium", unit_price: 1399, merchant_id: merchant1.id)
          item3 = Item.create!(id: 47, name:"Sneakers", description:"Red Converse", unit_price: 1299, merchant_id: merchant2.id)
          invoice1 = Invoice.create!(id: 45, customer_id: customer1.id, status: 1)
          invoice_item1 = InvoiceItem.create!(id: 45, item_id: item1.id, invoice_id: invoice1.id, quantity: 12, unit_price:1499 , status: 0)
          invoice_item2 = InvoiceItem.create!(id: 46, item_id: item2.id, invoice_id: invoice1.id, quantity: 15, unit_price:1399 , status: 1)
          invoice_item3 = InvoiceItem.create!(id: 47, item_id: item3.id, invoice_id: invoice1.id, quantity: 15, unit_price:1299 , status: 1)
          
          visit merchant_invoice_path(merchant1, invoice1)

          expect(page).to have_content("Total Revenue: $584.58")
          expect(page).to have_content("Total Discounted Revenue: $485.65")
        end
      end
    end
  end
end
