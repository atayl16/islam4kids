import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    buttonId: String,
    imageUrl: String
  }

  connect() {
    this.loadPayPalSDK()
  }

  loadPayPalSDK() {
    // Check if PayPal SDK is already loaded
    if (window.PayPal && window.PayPal.Donation) {
      this.renderButton()
      return
    }

    // Load PayPal SDK dynamically
    const script = document.createElement('script')
    script.src = 'https://www.paypalobjects.com/donate/sdk/donate-sdk.js'
    script.charset = 'UTF-8'
    script.onload = () => {
      this.renderButton()
    }
    script.onerror = () => {
      console.error('Failed to load PayPal SDK')
      this.element.innerHTML = '<p class="text-red-600 text-sm">Failed to load donation button. Please try again later.</p>'
    }
    document.head.appendChild(script)
  }

  renderButton() {
    if (!window.PayPal || !window.PayPal.Donation) {
      console.error('PayPal Donation SDK not available')
      return
    }

    try {
      window.PayPal.Donation.Button({
        env: 'production',
        hosted_button_id: this.buttonIdValue,
        image: {
          src: this.imageUrlValue,
          alt: 'Donate with PayPal button',
          title: 'PayPal - The safer, easier way to pay online!'
        }
      }).render(this.element)
    } catch (error) {
      console.error('Error rendering PayPal button:', error)
      this.element.innerHTML = '<p class="text-red-600 text-sm">Failed to load donation button. Please try again later.</p>'
    }
  }
}
