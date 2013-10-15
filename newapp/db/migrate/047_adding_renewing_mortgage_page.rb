class AddingRenewingMortgagePage < ActiveRecord::Migration
  def self.up
    Page.create!(
      :name => 'Mortgage Renewal',
      :text => %(h1. When does your mortgage renew?

Mortgage renewal is an important moment of opportunity. Let us contact you four months prior to your renewal to explain why. Just enter your email address and the maturity date of your mortgage.  There is no obligation.

At renewal, you may find your mortgage needs have changed. Perhaps this is the right time to tap some of your home equity for a renovation project? Or maybe you're considering a cottage or vacation property, or want to use some of your equity for other long-term investments. You should also take a look at your other debts; many Canadian homeowners have taken advantage of historically low rates – and rolled all their other higher-interest debts into their mortgage at renewal.

You'll also want to get the best rate. Having multiple lenders compete for your business is a great way to ensure you get the best rate for your situation.  We have access to over 50 lending institutions, including major banks, credit unions, trusts and other national and regional lenders, which means we can put significant negotiating power behind finding the best mortgage to fit your specific situation.
),
      :html => %(<h1>When does your mortgage renew?</h1>

<p>Mortgage renewal is an important moment of opportunity. Let us contact you four months prior to your renewal to explain why. Just enter your email address and the maturity date of your mortgage.  There is no obligation.</p>

<p>At renewal, you may find your mortgage needs have changed. Perhaps this is the right time to tap some of your home equity for a renovation project? Or maybe you're considering a cottage or vacation property, or want to use some of your equity for other long-term investments. You should also take a look at your other debts; many Canadian homeowners have taken advantage of historically low rates – and rolled all their other higher-interest debts into their mortgage at renewal.</p>

<p>You'll also want to get the best rate. Having multiple lenders compete for your business is a great way to ensure you get the best rate for your situation.  We have access to over 50 lending institutions, including major banks, credit unions, trusts and other national and regional lenders, which means we can put significant negotiating power behind finding the best mortgage to fit your specific situation.</p>
      )
    )
  end

  def self.down
    # ...
  end
end
