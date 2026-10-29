FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# نسخ كل الملفات الموجودة في الجذر مباشرة
COPY . .

# تنفيذ الـ restore والبناء بالاسم المباشر للملف لأنه في الجذر
RUN dotnet restore "MedicalCaravanApp.csproj"
RUN dotnet build "MedicalCaravanApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MedicalCaravanApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "MedicalCaravanApp.dll"]
