enum OrderStatusEnum {
  completed('completed'),
  processing('processing'),
  cancelled('cancelled');

  const OrderStatusEnum(this.status);
  final String status;
}

extension ConvertOrderStatus on String {
  OrderStatusEnum toEnum() {
    switch (this) {
      case 'completed':
        return OrderStatusEnum.completed;
      case 'processing':
        return OrderStatusEnum.processing;
      case 'cancelled':
        return OrderStatusEnum.cancelled;
      default:
        throw ArgumentError('$this : غلط آرڈر کی حیثیت');
    }
  }
}
