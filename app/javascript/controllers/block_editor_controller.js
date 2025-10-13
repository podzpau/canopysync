import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"]
  
  connect() {
    console.log("Block selector connected")
  }
  
  // Click to select a block
  selectBlock(event) {
    // Remove selection from all blocks
    document.querySelectorAll('.block-item').forEach(block => {
      block.classList.remove('border-sky-500', 'ring-2', 'ring-sky-400')
      block.classList.add('border-transparent')
    })
    
    // Add selection to clicked block
    const clickedBlock = event.currentTarget
    clickedBlock.classList.remove('border-transparent')
    clickedBlock.classList.add('border-sky-500', 'ring-2', 'ring-sky-400')
    
    console.log('Selected block:', clickedBlock.dataset.blockId)
  }
  
  // Responsive preview toggle
  setDevice(event) {
    const device = event.currentTarget.dataset.device
    const canvas = this.canvasTarget
    
    // Remove active state from all buttons
    document.querySelectorAll('.device-toggle').forEach(btn => {
      btn.classList.remove('bg-white', 'shadow-sm')
      btn.classList.add('hover:bg-white/50')
    })
    
    // Add active state to clicked button
    event.currentTarget.classList.add('bg-white', 'shadow-sm')
    event.currentTarget.classList.remove('hover:bg-white/50')
    
    // Apply device width
    canvas.classList.remove('max-w-6xl', 'max-w-2xl', 'max-w-sm')
    
    switch(device) {
      case 'desktop':
        canvas.classList.add('max-w-6xl')
        break
      case 'tablet':
        canvas.classList.add('max-w-2xl')
        break
      case 'mobile':
        canvas.classList.add('max-w-sm')
        break
    }
    
    console.log('Device set to:', device)
  }
}