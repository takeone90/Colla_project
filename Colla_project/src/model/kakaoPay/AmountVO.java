package model.kakaoPay;

public class AmountVO {
    private Integer total, tax_free, vat, point, discount;

	public void setTotal(Integer total) {
		this.total = total;
	}

	public void setTax_free(Integer tax_free) {
		this.tax_free = tax_free;
	}

	public void setVat(Integer vat) {
		this.vat = vat;
	}

	public void setPoint(Integer point) {
		this.point = point;
	}

	public void setDiscount(Integer discount) {
		this.discount = discount;
	}

	public Integer getTotal() {
		return total;
	}

	public Integer getTax_free() {
		return tax_free;
	}

	public Integer getVat() {
		return vat;
	}

	public Integer getPoint() {
		return point;
	}

	public Integer getDiscount() {
		return discount;
	}
}
