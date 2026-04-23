class Admin::DashboardController < AdminController
  def show
    @period = params[:period].presence_in(%w[today week month]) || "today"
    shop = @current_admin.shop

    base_orders = shop.orders.completed.in_period(@period)

    @total_revenue = base_orders.sum(:total_cents)
    @total_orders  = base_orders.count
    @aov           = @total_orders > 0 ? (@total_revenue / @total_orders) : 0
    @items_sold    = base_orders.sum(:item_count)

    @top_products = OrderItem.joins(:order)
      .merge(base_orders)
      .group(:product_name)
      .select("product_name, SUM(order_items.quantity) AS total_quantity, SUM(order_items.total_cents) AS total_revenue")
      .order("total_quantity DESC")
      .limit(10)

    @top_brands = OrderItem.joins(:order)
      .merge(base_orders)
      .where.not(brand_name: nil)
      .group(:brand_name)
      .select("brand_name, SUM(order_items.total_cents) AS total_revenue")
      .order("total_revenue DESC")
      .limit(5)

    @sales_by_day = base_orders
      .group("DATE(ordered_at)")
      .select("DATE(ordered_at) AS day, SUM(total_cents) AS revenue")
      .order("day")

    @peak_hours = base_orders
      .group("EXTRACT(HOUR FROM ordered_at)::integer")
      .count
      .sort_by { |hour, _| hour }
      .to_h

    raw_grid = base_orders
      .group("EXTRACT(DOW FROM ordered_at)::integer", "EXTRACT(HOUR FROM ordered_at)::integer")
      .count
    @peak_hours_grid = {}
    raw_grid.each do |(dow, hour), count|
      @peak_hours_grid[dow] ||= {}
      @peak_hours_grid[dow][hour] = count
    end
    @peak_hours_max = raw_grid.values.max || 1

    @recent_orders = shop.orders.order(ordered_at: :desc).limit(10).includes(:order_items)
  end
end
