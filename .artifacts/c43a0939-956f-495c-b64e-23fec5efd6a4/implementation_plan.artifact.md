# OgaFix MVP Implementation Plan

This implementation plan outlines the development strategy for **OgaFix**, a Nigeria-focused service marketplace connecting customers with verified professionals across Lagos (Lekki, Ajah, Victoria Island, Ikoyi) for core categories (Plumbing, Electrical, AC/Refrigeration, Generator repair, Cleaning, Carpentry, Painting, Appliance repair, Auto mechanics, Tailoring).

## User Review Required

> [!IMPORTANT]
> **Tech Stack Selection**:
> - **Mobile App**: Flutter (cross-platform iOS & Android supporting both Customer and Professional flows).
> - **Backend**: Node.js (NestJS/Express) or Go with a relational database (PostgreSQL) and object storage (AWS S3 / Supabase Storage).
> - **Payments**: Licensed Nigerian payment provider (e.g., Paystack / Flutterwave).
> - **Admin Dashboard**: Web-based admin dashboard (React/Flutter Web or Next.js).

> [!WARNING]
> **Regulatory & Legal Compliance**:
> - No automated refunds or escrow promises until reviewed by Nigerian counsel and payment provider terms are confirmed.
> - Identity verification documents must be securely stored with strict least-privilege access.

## Open Questions

1. Do you have a preferred backend language/framework (e.g., Node.js/TypeScript, Python, Go, or Supabase/Firebase backend)?
2. Would you prefer the Customer and Professional features within a single Flutter app with role switching, or separate Flutter app packages?

## Proposed Changes

### 1. Database Schema & Architecture
- Setup PostgreSQL relational database tables as specified in Section 15 & 16:
  - `users`, `customer_profiles`, `professional_profiles`, `business_profiles`
  - `categories`, `services`, `jobs`, `job_media`, `job_locations`, `quotes`, `bookings`, `booking_events`
  - `professional_services`, `availability`, `portfolio_items`, `certifications`, `service_areas`
  - `conversations`, `messages`, `attachments`, `notifications`
  - `payments`, `payouts`, `refunds`, `fees`, `invoices`
  - `verification_requests`, `verification_documents`, `reviews`, `reports`, `disputes`, `audit_logs`

### 2. Backend API Services
- Build RESTful API endpoints for Auth, Users, Categories, Services, Jobs, Quotes, Bookings, Messages, Payments, Payouts, Verification, Disputes, and Admin operations.
- Implement RBAC (Role-Based Access Control), rate limiting, request validation, idempotency for financial actions, and webhook processing for payment providers.

### 3. Customer Mobile App (Flutter)
- **Authentication**: Phone OTP login flow.
- **Discovery**: Home screen, Category browsing, Location setting, Service search.
- **Job Posting & Quotes**: "Tell OgaFix What's Wrong" / Post a Job flow (text, photos, budget, timing). Quote comparison screen.
- **Booking & Chat**: Booking confirmation, real-time in-app chat, job tracking (Confirmed → On the way → Arrived → Started → Completed).
- **Payments & Reviews**: Payment integration, completion confirmation, rating & review flow, dashboard.

### 4. Professional Mobile App / Mode (Flutter)
- **Onboarding & Verification**: Registration, profession setup, identity verification document upload.
- **Job Management**: Job feed, submit quote, calendar, active job tracking, evidence upload (before/after photos).
- **Earnings & Invoices**: Earnings dashboard, payouts history, invoice creation.

### 5. Admin Dashboard (Web)
- Overview analytics, user/professional management, verification review queue, marketplace oversight, finance/payouts, trust & safety (disputes, fraud flags, reports), and support ticketing.

## Verification Plan

### Automated Tests
- Backend unit and integration tests for auth, job booking flows, quote creation, and payment idempotency webhook handling.
- Flutter widget and unit tests for core customer and professional navigation and state management.

### Manual Verification
- End-to-end walkthrough on Android emulator / simulator:
  1. Customer registers via OTP, searches for Plumbing, posts a job.
  2. Professional registers, completes verification, views job feed, and submits a quote.
  3. Customer reviews quote, books professional, processes mock payment.
  4. Professional accepts, tracks job, uploads completion evidence.
  5. Customer confirms completion and leaves a verified review.
  6. Admin reviews user/pro status, verification documents, and checks audit logs.
