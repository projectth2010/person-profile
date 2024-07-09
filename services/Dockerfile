FROM node:18\n\nWORKDIR /usr/src/app\n\nCOPY package*.json ./\n\nRUN npm install\n\nCOPY . .\n\nCMD ["node", "src/index.js"] 
