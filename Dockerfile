ARG PLATFORM=linux/amd64
FROM --platform=$PLATFORM professorcha0s/winebase:latest

ARG GRLEVEL3_URL=https://www.grlevelx.com/downloads/grlevel3_2_setup.exe \
    GRLEVEL3_UPDATE_URL=https://www.grlevelx.com/downloads/grlevel3_2_update.exe

# Download GRLevel3 installer
RUN wget -O /wine/drive_c/grlevelx/gr2analyst_3_setup.exe $GRLEVEL3_URL && \
    wget -O /wine/drive_c/grlevelx/grlevel3_2_update.exe $GRLEVEL3_UPDATE_URL 

# # Copy GRLevel3 installer
# ADD grlevelx/ /wine/drive_c/grlevelx/

# Install directx
# RUN WINEPREFIX=/wine WINEARCH=win32 winetricks dxvk
RUN WINEPREFIX=/wine WINEARCH=win32 winetricks d3dx11_43

# Install GRLevel3
RUN rm -f /tmp/.X0-lock && /usr/bin/Xvfb :0 -screen 0 1024x768x16 & sleep 1 && \
    WINEPREFIX=/wine WINEARCH=win32 wine /wine/drive_c/grlevelx/gr2analyst_3_setup.exe /VERYSILENT && \
    WINEPREFIX=/wine WINEARCH=win32 wine /wine/drive_c/grlevelx/grlevel3_2_update.exe /VERYSILENT

# Copy GRLevel3 supervisord config
ADD app/grlevelx.conf /etc/supervisor/conf.d/

# Copy grlevelx.sh
ADD app/grlevelx.sh /opt/grlevelx.sh
RUN chmod +x /opt/grlevelx.sh

# Setcap on wine binaries
# RUN  setcap cap_net_raw+epi /usr/bin/wine-preloader

# Expose noVNC port
EXPOSE 8080 
