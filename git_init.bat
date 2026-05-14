@echo off
cd /d "c:\Users\Damir\OneDrive\Desktop\Gazgan city"
echo # Gazgan-CITY >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/damirjonnurmurodov-ui/Gazgan-CITY.git
git push -u origin main
pause
