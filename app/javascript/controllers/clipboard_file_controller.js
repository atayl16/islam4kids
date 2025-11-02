import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard-file"
export default class extends Controller {
  static targets = ["input", "dropZone", "feedback", "browseButton"]
  
  connect() {
    this.boundHandlePaste = this.handlePaste.bind(this)
    document.addEventListener('paste', this.boundHandlePaste)
    
    // Listen for file input changes to show feedback
    if (this.hasInputTarget) {
      this.inputTarget.addEventListener('change', this.fileSelected.bind(this))
    }
  }
  
  disconnect() {
    document.removeEventListener('paste', this.boundHandlePaste)
  }
  
  openFileDialog() {
    if (this.hasInputTarget) {
      this.inputTarget.click()
    }
  }
  
  handlePaste(event) {
    // Only handle if user clicked on the drop zone first (has focus)
    if (!this.hasDropZoneTarget || !this.dropZoneTarget.contains(document.activeElement)) {
      return
    }
    
    const items = event.clipboardData.items
    
    for (let i = 0; i < items.length; i++) {
      if (items[i].type.indexOf('image') !== -1) {
        const blob = items[i].getAsFile()
        const dataTransfer = new DataTransfer()
        dataTransfer.items.add(blob)
        this.inputTarget.files = dataTransfer.files
        this.inputTarget.dispatchEvent(new Event('change', { bubbles: true }))
        event.preventDefault()
        this.showFeedback('✓ Pasted successfully!')
        break
      }
    }
  }
  
  fileSelected() {
    if (this.hasInputTarget && this.inputTarget.files.length > 0) {
      const fileName = this.inputTarget.files[0].name
      this.showFeedback(`✓ Image ready: ${fileName}`)
    }
  }
  
  showFeedback(message) {
    if (this.hasFeedbackTarget) {
      this.feedbackTarget.textContent = message
      this.feedbackTarget.classList.remove('hidden')
      setTimeout(() => {
        this.feedbackTarget.textContent = ''
        this.feedbackTarget.classList.add('hidden')
      }, 3000)
    }
  }
}

