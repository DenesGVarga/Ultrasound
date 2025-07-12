pkg load image

% === ALAP PARAMÉTEREK === %
fa_atmero = 20;          % Fa átmérő (cm)
ek_hossz = 3;            % Acél ék hossza (cm)
ek_vastagsag = 1;        % Acél ék vastagsága (cm)
skala = 20;              % Pixel/cm arány
grid_size = 1000;        % Rács mérete
center = [grid_size/2, grid_size/2];
radius = (fa_atmero/2) * skala;

% Anyagparaméterek
c_fa = 1500;            % Hangsebesség fában (m/s)
c_acel = 5000;          % Hangsebesség acélban (m/s)
frekvencia = 40e3;      % 40 kHz
lambda_fa = c_fa/frekvencia;

% Stabilitási feltétel
dx = lambda_fa/8;
dt = 0.6*dx/(sqrt(2)*c_acel);

% Csillapítási tényezők
damping_fa = 0.992;
damping_acel = 0.998;

% === INICIALIZÁLÁS === %
u_prev = zeros(grid_size);
u = zeros(grid_size);
u_next = zeros(grid_size);
c_map = c_fa * ones(grid_size);

% === GEOMETRIA KIALAKÍTÁSA === %
[xx, yy] = meshgrid(1:grid_size);
tavolsag = sqrt((xx-center(1)).^2 + (yy-center(2)).^2);
c_map(tavolsag > radius) = 0; % Fa körvonala

% === ACÉL ÉK (700X, 500Y) === %
ek_center_x = 700;
ek_center_y = 500;
ek_hossz_px = round(ek_hossz*skala);
ek_vastagsag_px = round(ek_vastagsag*skala);

ek_start_x = 690;
ek_end_x = 710;
ek_start_y = 470;
ek_end_y = 530;

c_map(ek_start_x:ek_end_x, ek_start_y:ek_end_y) = c_acel;

% === 3 ADÓ A FÉM ÉK BELSŐ RÉSZÉBEN === %
ado_tav_y = round(ek_vastagsag_px / 3);
ado_pontok = [
    490,700;
    500,700;
    510,700;
];
ado_sugar = 5;

% === KÖRVONALAK === %
fa_korvonal = (abs(tavolsag - radius) <= 1.5);
ek_korvonal = zeros(grid_size);
ek_korvonal(ek_start_x:ek_end_x, [ek_start_y, ek_end_y]) = 1;
ek_korvonal([ek_start_x, ek_end_x], ek_start_y:ek_end_y) = 1;

% === SZIMULÁCIÓ === %
num_frames = 350;
for t = 1:num_frames
    % Hullámgenerálás
    for i = 1:rows(ado_pontok)
        dist = sqrt((xx-ado_pontok(i,1)).^2 + (yy-ado_pontok(i,2)).^2);
        aktiv = (dist <= ado_sugar);
        u(aktiv) += 0.5*sin(2*pi*frekvencia*t*dt)*exp(-(t-30)^2/200);
    end

    % Hullámegyenlet
    for x = 2:grid_size-1
        for y = 2:grid_size-1
            if c_map(x,y) > 0
                laplacian = u(x+1,y) + u(x-1,y) + u(x,y+1) + u(x,y-1) - 4*u(x,y);
                u_next(x,y) = (c_map(x,y)^2 * dt^2 / dx^2) * laplacian + 2*u(x,y) - u_prev(x,y);

                if c_map(x,y) == c_acel
                    u_next(x,y) *= damping_acel;
                else
                    u_next(x,y) *= damping_fa;
                end

                if norm([x,y]-center) > radius*0.85
                    u_next(x,y) *= 0.92;
                end
            end
        end
    end

    % Megjelenítés
    imagesc(u, [-0.2 0.2]);
    hold on;

    % Körvonalak
    [row, col] = find(fa_korvonal);
    plot(col, row, 'w.', 'MarkerSize', 1);
    [row, col] = find(ek_korvonal);
    plot(col, row, 'r.', 'MarkerSize', 1);

    % Adók
    for i = 1:rows(ado_pontok)
        rectangle('Position', [ado_pontok(i,1)-ado_sugar, ado_pontok(i,2)-ado_sugar, ...
              2*ado_sugar, 2*ado_sugar], 'Curvature', [1 1], ...
             'EdgeColor', 'green', 'LineWidth', 1);
    end

    hold off;
    colormap("jet");
    colorbar;
    title(sprintf("Adók a fém ék belsejében – %d. képkocka (%.2f µs)", t, t*dt*1e6));
    axis equal;
    drawnow;

    % Léptetés
    u_prev = u;
    u = u_next;
    u_next = zeros(grid_size);
end

