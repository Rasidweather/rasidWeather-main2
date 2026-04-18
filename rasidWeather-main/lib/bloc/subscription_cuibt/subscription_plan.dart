enum SubscriptionPlan { none, silver, gold, premium }

SubscriptionPlan planFromProductId(String? productId) {
  switch (productId) {
    case 'whats-annual':
      return SubscriptionPlan.silver;
    case 'annual_package':
      return SubscriptionPlan.gold;
    case 'annual_package_2':
      return SubscriptionPlan.premium;
    default:
      return SubscriptionPlan.none;
  }
}

bool isVipPlan(SubscriptionPlan plan) =>
    plan == SubscriptionPlan.silver ||
        plan == SubscriptionPlan.gold ||
        plan == SubscriptionPlan.premium;
