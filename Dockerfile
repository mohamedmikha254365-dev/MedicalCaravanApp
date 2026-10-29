FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# نسخ محتويات مجلد المشروع الحالي
COPY . .

# تنفيذ الـ restore و الـ build مباشرة بالاسم الصحيح للملف الموجود في مجلدك
RUN dotnet restore "MedicalCaravanApp.csproj"
RUN dotnet build "MedicalCaravanApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MedicalCaravanApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MedicalCaravanApp.dll"]
