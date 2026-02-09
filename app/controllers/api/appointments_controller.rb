class Api::AppointmentsController < ApplicationController

  # GET /api/appointments?salon_id=xxx&date=xxxx
  def index
  appointments = Appointment.where(salon_id: params[:salon_id])

  appointments = appointments.where(date: params[:date]) if params[:date]

  render json: appointments
  end

  # GET /api/appointments/availability?salon_id=xxx&date=xxxx
  def availability
    times = [
      "09:00","10:00","11:00",
      "13:00","14:00","15:00",
      "16:00","17:00"
    ]

    booked = Appointment.where(
      salon_id: params[:salon_id],
      date: params[:date]
    ).pluck(:hour).map { |h| h.strftime("%H:%M") }

    available = times - booked

    render json: {
      available: available,
      booked: booked
    }
  end

  # POST /api/appointments
  def create
    appointment = Appointment.new(appointment_params)
    appointment.status ||= "pending"

    if Appointment.exists?(
      salon_id: appointment.salon_id,
      date: appointment.date,
      hour: appointment.hour
    )
      return render json: { error: "Horário já ocupado" }, status: :unprocessable_entity
    end

    if appointment.save
      render json: appointment, status: :created
    else
      render json: appointment.errors, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotUnique
    render json: { error: "Horário já agendado" }, status: :unprocessable_entity
  end

  # PATCH /api/appointments/:id/confirm
  def confirm
    appointment = Appointment.find(params[:id])
    appointment.update(status: "confirmed")

    render json: appointment
  end

  # PATCH /api/appointments/:id/finish
  def finish
    appointment = Appointment.find(params[:id])
    appointment.update(status: "done")

    render json: appointment
  end

  # PATCH /api/appointments/:id/cancel
  def cancel
    appointment = Appointment.find(params[:id])
    appointment.update(status: "canceled")

    render json: appointment
  end

  private

  def appointment_params
    params.require(:appointment).permit(
      :salon_id,
      :service_id,
      :date,
      :hour,
      :status
    )
  end
end
