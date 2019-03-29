// Install with:
// sudo bash -c "cat /home/gauthier/dotfiles/slack_light_add_to_ssb-interop.js >> /usr/lib/slack/resources/app.asar.unpacked/src/static/ssb-interop.js"

// First make sure the wrapper app is loaded
document.addEventListener("DOMContentLoaded", function() {

   // Then get its webviews
   let webviews = document.querySelectorAll(".TeamView webview");

   // Fetch our CSS in parallel ahead of time
   const cssPath = 'https://raw.githubusercontent.com/mallowigi/slack-one-dark-theme/master/custom.css';
   let cssPromise = fetch(cssPath).then(response => response.text());

   let customCustomCSS = `
   :root {
      /* Modify these to change your theme colors: */
     --primary: #fbd091;
     --accent: #00f; /* what is this? */
     --text: #222;
     --background: #968e75;
     --background-elevated: #a69e85;

     /* These should be less important: */
     --background-hover: lighten(#3B4048, 10%);
     --background-light: #AAA;
     --background-bright: #FFF;

     --border-dim: #666;
     --border-bright: var(--primary);

     --text-bright: #FFF;
     --text-dim: #555c69;
     --text-special: var(--primary);
     --text-accent: var(--text-bright);

     --scrollbar-background: #000;
     --scrollbar-border: var(--primary);

     --yellow: #fc0;
     --green: #98C379;
     --cyan: #56B6C2;
     --blue: #61AFEF;
     --purple: #C678DD;
     --red: #E06C75;
     --red2: #BE5046;
     --orange: #D19A66;
     --orange2: #E5707B;
     --gray: #3E4451;
     --silver: #9da5b4;
     --black: #21252b;
      }
   `
    
   // Insert a style tag into the wrapper view
   cssPromise.then(css => {
      let s = document.createElement('style');
      s.type = 'text/css';
      s.innerHTML = css + customCustomCSS;
      document.head.appendChild(s);
   });

   // Wait for each webview to load
   webviews.forEach(webview => {
      webview.addEventListener('ipc-message', message => {
         if (message.channel == 'didFinishLoading')
            // Finally add the CSS into the webview
            cssPromise.then(css => {
               let script = `
                     let s = document.createElement('style');
                     s.type = 'text/css';
                     s.id = 'slack-custom-css';
                     s.innerHTML = \`${css + customCustomCSS}\`;
                     document.head.appendChild(s);
                     `
               webview.executeJavaScript(script);
            })
      });
   });
});
